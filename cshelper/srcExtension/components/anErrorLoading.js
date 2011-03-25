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

try {
    Components.utils.import("resource://cshelper/modules/logger.jsm");
    Components.utils.import("resource://cshelper/modules/session.jsm");
} catch(e) {
    /* importing our own resources fails during xpcom registration.  We
      must let this pass by so the object can get registered properly.
      this is due to nsIResProtocolHandler::GetSubstitution not having
      the resource mapping for new installed extensions at the time of
      xpcom registration.   This seems to happen with the FIRST component
      only, so this file is named starting with an "a" to beat other
      component files, which load normally afterwards.  */
    Components.utils.reportError("anError: loading modules through mozIJSSubScriptLoader");
        const loader = Cc["@mozilla.org/moz/jssubscript-loader;1"].getService(Ci["mozIJSSubScriptLoader"]);
    try {
        loader.loadSubScript("chrome://cshelper/content/modules/logger.jsm", this);
    } catch(e) {
        Components.utils.reportError("anError: unable to load module logger\n");
    }
    
    try {
        loader.loadSubScript("chrome://cshelper/content/modules/session.jsm", this);
    } catch(e) {
        Components.utils.reportError("anError: unable to load module session\n");
    }
}
    
var log = logging.getLogger("cshelper.service.loaderror");
log.setLevel(logging.DEBUG);
log.debug("loading in progress");

function anError() {
}
anError.prototype.constructor = anError;

(function() {

this.classDescription = "cshelper Fix Loading XPCOM Service";
this.classID = Components.ID("{620B80DC-4A77-11E0-B6D4-B234DFD72085}");
this.contractID = "@creax.de/AnError;1"
this.QueryInterface = XPCOMUtils.generateQI([Ci.nsISupports])

}).apply(anError.prototype);

function NSGetModule(compMgr, fileSpec) {
  return XPCOMUtils.generateModule([anError]);
}
