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

var EXPORTED_SYMBOLS = ["session"];

if (typeof(Cc) == "undefined") 
{
	const Cc = Components.classes;
	const Ci = Components.interfaces;
}
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");

Components.utils.import("resource://cshelper/modules/logger.jsm");

var log = logging.getLogger("cshelper.session");
log.setLevel(logging.DEBUG);
log.debug("session module is loading");

function session() {
    this.transport = null;
}

session.prototype = {
    
    connect: function(host_name, host_port) {
        try {
            var transportService =
                Components.classes["@mozilla.org/network/socket-transport-service;1"].getService(Components.interfaces.nsISocketTransportService);
            var transport = transportService.createTransport(null, 0, host_name, host_port, null);
            if (!transport) {
                this.onNotify("connect-failed", "Unable to create trasport for "+host_name+":"+host_port);
                return;
            }
            // 5 second timeout for connections
            transport.setTimeout(Components.interfaces.nsISocketTransport.TIMEOUT_CONNECT, 5);
            this.setTransport(transport);
        } catch(ex) {
            this.onNotify("connect-failed", "Unable to connect to "+host_name+":"+host_port+"; Exception occured "+ex);
            this.disconnect();
        }
    },
    
    setTransport: function(transport) {
        try {
            this.transport = transport;
            this.raw_istream = this.transport.openInputStream(0, 0, 0);
            this.ostream = this.transport.openOutputStream(0,0,0);
            this.istream = Components.classes["@mozilla.org/binaryinputstream;1"].
                                createInstance(Components.interfaces.nsIBinaryInputStream);
            this.istream.setInputStream(this.raw_istream);
            if (!this.transport.isAlive()) {
                if ("nsIThreadManager" in Components.interfaces) {
                    // Introduced in Moz 1.9 / FF 3
                    var mainThread = Components.classes["@mozilla.org/thread-manager;1"].getService(Components.interfaces.nsIThreadManager).mainThread;
                    var asyncOutputStream = this.ostream.QueryInterface(Components.interfaces.nsIAsyncOutputStream);
                    // We need to be able to write at least one byte.
                    asyncOutputStream.asyncWait(this, 0, 1, mainThread); // was: mainThread
                } else {
                    // Only available in FF2, dropped from Moz 1.9
                    // XXX evenTarget? http://lxr.mozilla.org/mozilla1.8/source/netwerk/base/public/nsITransport.idl
                    var eq = Components.classes["@mozilla.org/event-queue-service;1"]
                                .getService(Components.interfaces.nsIEventQueueService);
                    this.transport.setEventSink(this,
                                eq.getSpecialEventQueue(eq.UI_THREAD_EVENT_QUEUE));
                }
            } else {
                this.onConnect();
            }
        } catch(ex) {
            this.onNotify("connect-failed", "setTransport failed, Unable to connect; Exception "+ex);
            log.exception(ex, "setTransport failed: ");
            this.disconnect();
        }
    },

    // Used in Firefox 3 (and up) - Moz 1.9
    onOutputStreamReady: function() {
        this.onConnect();
    },

    onTransportStatus: function(transport, status, progress, max) {
        if (transport != this.transport) {
            dump("!!!!!! different transport? !!!!!\n");
        }
        if (status == Components.interfaces.nsISocketTransport.STATUS_CONNECTED_TO) {
            // finish connecting!
            this.onConnect();
        } else
        if (status == Components.interfaces.nsISocketTransport.STATUS_RESOLVING) {
            this.onNotify("transport-status-resolving", null);
        } else
        if (status == Components.interfaces.nsISocketTransport.STATUS_CONNECTING_TO) {
            this.onNotify("transport-status-connecting", null);
        } else
        if (status == Components.interfaces.nsISocketTransport.STATUS_SENDING_TO) {
            this.onNotify("transport-status-sending", null);
        } else
        if (status == Components.interfaces.nsISocketTransport.STATUS_WAITING_FOR) {
            this.onNotify("transport-status-waiting", null);
        } else
        if (status == Components.interfaces.nsISocketTransport.STATUS_RECEIVING_FROM) {
            this.onNotify("transport-status-receiving", null);
        } else {
            this.onNotify("transport-status-unknown", status);
        }
        
    },

    onConnect: function() {
        try {
            // start the async read
            this.pump = Components.classes["@mozilla.org/network/input-stream-pump;1"].
                            createInstance(Components.interfaces.nsIInputStreamPump);
            this.pump.init(this.raw_istream, -1, -1, 0, 0, false);
            this.pump.asyncRead(this, null);

            this.onNotify("transport-status-connected", null);
        } catch(ex) {
            log.exception(ex, "Session::onConnect failed: ");
            this.onNotify("connect-failed", "Unable to connect; Exception occured "+ex);
            this.disconnect();
        }
    },
    
    disconnect: function() {
        if ("istream" in this && this.istream)
            this.istream.close();
        if ("ostream" in this && this.ostream)
            this.ostream.close();
        if ("transport" in this && this.transport)
          this.transport.close(Components.results.NS_OK);
    
        this.pump = null;
        this.istream = null;
        this.ostream = null;
        this.transport = null;
        this.onNotify("connect-closed", null);
    },

    readData: function(count) {
        return this.istream.readBytes(count);
    },
    
    writeData: function(data, dataLen) {
        try {
            if (!this.transport) {
                log.debug("Session.transport is not available");
                return -1;
            }
            if (arguments.length == 0) {
                log.debug("Session.writeData called with no args");
                return -1;
            } else if (arguments.length == 1) {
                dataLen = data.length;
            }
    
    
            var str1 = this.expand(data);
            if (str1.length > 1000) {
                str1 = str1.substr(0, 1000) + "...";
            }
            log.debug("writeData: [" + str1 + "]");
    
            var num_written = this.ostream.write(data, dataLen);
            if (num_written != dataLen) {
                log.warn("Expected to write "
                          + dataLen
                          + " chars, but wrote only "
                          + num_written);
                if (num_written == 0) {
                    log.warn("bailing out...");
                    this.disconnect();
                }
            }
            return num_written;
        } catch(ex) {
            log.exception(ex, "writeData failed: ");
        }
        return -1;
    },

    expand: function(s) {
        // JS doesn't have foo ||= val
        if (!this._hexEscape) {
            this._hexEscape = function(str) {
                var res1 = parseInt(str.charCodeAt(0)).toString(16);
                var leader = res1.length == 1 ? "0" : "";
                return "%" + leader + res1;
            };
        }
        return s.replace(/[\x00-\x09\x11-\x1f]/g, this._hexEscape);
    },
    QueryInterface: XPCOMUtils.generateQI([Ci.iSDService,
                                           Ci.nsIStreamListener,
                                           Ci.nsITransportEventSink,
                                           Ci.nsIOutputStreamCallback])
};

