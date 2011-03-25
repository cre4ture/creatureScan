/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is Komodo code.
 * 
 * The Initial Developer of the Original Code is ActiveState Software Inc.
 * Portions created by ActiveState Software Inc are Copyright (C) 2000-2008
 * ActiveState Software Inc. All Rights Reserved.
 * 
 * Contributor(s):
 *   Shane Caraveo, ActiveState Software Inc
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK ***** */


const Cc = Components.classes;
const Ci = Components.interfaces;
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

Components.utils.import("resource://cshelper/modules/logger.jsm");

var log = logging.getLogger("cshelper.manager");
log.setLevel(logging.DEBUG);
log.debug("server module is loading");

var connections = [];
var listeners = {};
var services = {};

const URI_BRAND_PROPERTIES      = "chrome://branding/locale/brand.properties";

function SocketServer() {
    this.prefs = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefService)
        .getBranch("cshelper.");
    this.prefs.QueryInterface(Components.interfaces.nsIPrefBranch2);
    this.prefs.addObserver("", this, false);
    
    // get the application name
    var sbs = Cc["@mozilla.org/intl/stringbundle;1"].getService(Ci.nsIStringBundleService);
    var brandBundle = sbs.createBundle(URI_BRAND_PROPERTIES);
    this.appName = brandBundle.GetStringFromName("brandShortName");

}
SocketServer.prototype = {
    observe: function(subject, topic, data)
    {
        if (topic == "app-startup") {
            log.debug("observed app-startup notification");
            this.startServices();
            return;
        }
        
        if (topic != "nsPref:changed")
        {
            return;
        }
    
        // split the data on .
        var pname = data.split('.');
        this.stop(pname[0]);
        this.start(pname[0]);
    },
    startServices: function() {
        //alert("starting service "+logging.getObjectTree(SD, true));
        var catman = Components.classes["@mozilla.org/categorymanager;1"].
                        getService(Components.interfaces.nsICategoryManager);
        var services = catman.enumerateCategory('cshelper-service');
        while (services.hasMoreElements()) {
            var svc = services.getNext() 
            svc.QueryInterface(Components.interfaces.nsISupportsCString);
            this.start(svc.data);
        }
    },
    start: function(serviceName) {
        log.info("starting listener "+serviceName);
        try {
            var server = null;
            var service = Components.classes["@creax.de/cshelperService?type="+serviceName+";1"].createInstance(Components.interfaces.iSDService);
            services[service.port] = serviceName;
            this.stop(serviceName);
            listeners[serviceName] = Components.classes["@mozilla.org/network/server-socket;1"].
                createInstance(Components.interfaces.nsIServerSocket);
            listeners[serviceName].init(service.port,
                                  service.loopbackOnly,
                                  service.backlog);
            listeners[serviceName].asyncListen(this);
        } catch(e) {
            log.debug(e);
            log.exception(e);
        }
    },
    stop: function(serviceName) {
        if (typeof(listeners[serviceName]) != 'undefined') {
            log.info("stopping listener for "+serviceName);
            var listener = listeners[serviceName];
            listener.close();
        }
    },
    onSocketAccepted: function(/*nsIServerSocket*/ aServ, /*nsISocketTransport*/ aTransport) {
        var serviceName = services[aServ.port];
        log.info("socket connection recieved on port "+aServ.port + " for "+ serviceName);
        try {
            var session = Components.classes["@creax.de/cshelperService?type="+serviceName+";1"].createInstance(Components.interfaces.iSDService);
            session.setTransport(aTransport);
            connections.push(session);
        } catch(e) {
            log.debug(e);
            log.exception(e);
            this.stop(serviceName);
        }
    },
    onStopListening: function(/*nsIServerSocket*/ aServ, /*nsresult*/ aStatus) {
        log.info("server has stopped listening on port "+aServ.port+" status: "+aStatus);
    },
    classDescription: "cshelper Socket Server",
    classID: Components.ID("{361E978E-4A77-11E0-9851-7834DFD72085}"),
    contractID: "@creax.de/cshelper/socketserver;1",
    QueryInterface: XPCOMUtils.generateQI([Ci.iSDServiceManager,
                                           Ci.nsIServerSocketListener,
                                           Ci.nsIObserver]),
    _xpcom_categories: [{category: "app-startup", entry: "cshelper-connector-server"}]
};

function NSGetModule(compMgr, fileSpec) {
  return XPCOMUtils.generateModule([SocketServer]);
}

log.debug("server module loaded");
