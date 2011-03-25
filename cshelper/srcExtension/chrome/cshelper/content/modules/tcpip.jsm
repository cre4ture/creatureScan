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

var EXPORTED_SYMBOLS = ["echoClient"];

const Cc = Components.classes;
const Ci = Components.interfaces;
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

Components.utils.import("resource://cshelper/modules/logger.jsm");
Components.utils.import("resource://cshelper/modules/session.jsm");
    
var log = logging.getLogger("cshelper.service.tcpip");
log.setLevel(logging.DEBUG);
log.debug("loading tcpip Client");

function echoClient() {
    this.name = "tcpip";
    this.prefs = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefService)
        .getBranch("cshelper.tcpip.");
    this.enabled = this.prefs.getBoolPref("enabled");
    this.port = this.prefs.getIntPref("port");
    this.loopbackOnly = this.prefs.getBoolPref("loopbackOnly");
    this.backlog = this.prefs.getIntPref("backlog");
}

echoClient.prototype = new session();
echoClient.prototype.constructor = echoClient;

(function() {

this.onNotify = function(topic, message) {
    //alert(topic + " " + message +"\n");
    log.debug(topic + " " + message);
}
this.onStartRequest = function(request, ctx) {
    log.debug("onStartRequest");
    this.writeData("HELLO @ CS ECHO SERVICE");
}
this.onStopRequest = function(request, ctx, status) {
    log.debug("onStopRequest");
}
this.onDataAvailable = function(request, ctx, inputStream, offset, count) {
    var data = this.readData(count);
    log.debug("onDataAvailable: "+data);
    this.writeData(data);
}

}).apply(echoClient.prototype);

