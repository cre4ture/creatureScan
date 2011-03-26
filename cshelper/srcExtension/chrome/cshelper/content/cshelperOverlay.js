
/**
* cshelper namespace.
*/
if ("undefined" == typeof(cshelper)) {
	var cshelper = {};
};

function cshelper_myTestLog(document, msg) {
	var log = document.getElementById('playerName');
	log.innerHTML += '<br>'+msg;
}

/**
* Controls the browser overlay for the Hello World extension.
*/
cshelper.BrowserOverlay = {

	statusClicked : function(aEvent) {
		
		if ("undefined" == typeof(this.active)) {
			this.active = true;
		}
		
		//window.alert("click");
		
		switch (aEvent.button) {
			case 0:   // linke maustaste
				//window.alert("linke taste");
				this.active = !this.active;
				if (this.active) {
					window.alert("cSHelper is now active!")
				} else {
					window.alert("cSHelper is disabled!")
				}
				/*var status_panel = panel.getElementById("cshelper-status");
				if (status_panel == NULL)
					window.alert("failed to get cshelper-status");
				else
					window.alert("succed to get cshelper-status");*/
				break;
			case 1:   // mittlere maustaste
				//window.alert("mittlere taste");
			break;
			case 2:   // rechte maustaste
				//window.alert("rechte taste");
				//document.getElementById('gm-status-popup').openPopup(
				//    document.getElementById('gm-status'),
				//    'before_end', 0, 0, false, false);
			break;
		}
		
		return false;
	},
	
	getUniUrl : function(document) {
		return document.location.hostname.toLowerCase();
	},
	
	isHelperActiveFor : function(document) {
		
		var uni_url = this.getUniUrl(document);
		
		const Cc = Components.classes;
		const Ci = Components.interfaces; 
		
		var unis = Cc["@mozilla.org/preferences-service;1"]
			.getService(Components.interfaces.nsIPrefService)
				.getBranch("cshelper.hostlist.");
		
		if (unis.prefHasUserValue(uni_url)) {
			// entry exists -> is active?
			return unis.getBoolPref(uni_url);
		} else {
			var def_value = true; // no entry -> all unis are active by default
			unis.setBoolPref(uni_url, def_value);
			return def_value; 
		}
		
	},
	
	getTCPPort : function(uni_url) {
	
		const Cc = Components.classes;
		const Ci = Components.interfaces; 
		
		var uni_prefs = Cc["@mozilla.org/preferences-service;1"]
			.getService(Components.interfaces.nsIPrefService)
				.getBranch("cshelper.host." + uni_url + ".");

		if (uni_prefs.prefHasUserValue("port")) {
			return uni_prefs.getIntPref("port");
		} else {
			return -1;
		}
	},
	
	doWeUseTCP : function(document) {
		return (this.getTCPPort(this.getUniUrl(document)) > 0);
	},
	
	getTCPConnection : function(uni_url)
	{
		if ("undefined" == typeof(this.connection)) {
			this.connection = {}
		}
		
		if ("undefined" == typeof(this.connection[uni_url])) {
			this.connection[uni_url] = {}
		}
		
		const connection = this.connection[uni_url];
		
		if (
					("undefined" == typeof(connection.outputStream)) ||
					(false == connection.transport.isAlive())
				) {
			
			var port = this.getTCPPort(uni_url);

			const Cc = Components.classes;
			const Ci = Components.interfaces; 
			var socketTransportService = Components.classes['@mozilla.org/network/socket-transport-service;1']
				.getService(Components.interfaces.nsISocketTransportService); 
			connection.transport = socketTransportService.createTransport(null, null, "localhost", port, null); 
			connection.outputStream = connection.transport.openOutputStream(1, 0, 0); 
			connection.inputStream = connection.transport.openInputStream(1, 0, 0);
			
		}
		
		return connection;
	},
	
	sendStringThroughTCPIP : function(string, uni_url)
	{
		
		out = this.getTCPConnection(uni_url).outputStream;
		out.write(string, string.length);
		var endmsg = "\n\rCS:HELPER:END:OF:TRANSMISSION\n\r";
		out.write(endmsg, endmsg.length);
		
	},
	
	sendHTML_To_cS_TCPIP : function(string, event, document)
	{
		string = "SourceURL:" + event.originalTarget.location.href + " " + string;
		this.sendStringThroughTCPIP(string, this.getUniUrl(document));
	}

}

cshelper.BrowserOverlay.sendTCPIP = true;

function copyToClipboard(string, event, document)	{
	// cshelper_myTestLog(document, ' COPY_BEGIN  ');
	var str = Components.classes["@mozilla.org/supports-string;1"]. createInstance(Components.interfaces.nsISupportsString);
	var trans = Components.classes["@mozilla.org/widget/transferable;1"]. createInstance(Components.interfaces.nsITransferable);
	var clipid = Components.interfaces.nsIClipboard;
	var clip = Components.classes["@mozilla.org/widget/clipboard;1"].getService(clipid);
	trans.addDataFlavor("text/html");
	str.data = "SourceURL:" + event.originalTarget.location.href + " " +string;
	trans.setTransferData("text/html",str,string.length * 2);
	clip.setData(trans,null,clipid.kGlobalClipboard);
	// cshelper_myTestLog(document, ' COPY_END  ');
}

function copyToClipboard2(string, event, document)	{
	var str = Components.classes["@mozilla.org/supports-string;1"]. createInstance(Components.interfaces.nsISupportsString);
	var trans = Components.classes["@mozilla.org/widget/transferable;1"]. createInstance(Components.interfaces.nsITransferable);
	var clipid = Components.interfaces.nsIClipboard;
	var clip = Components.classes["@mozilla.org/widget/clipboard;1"].getService(clipid);
	trans.addDataFlavor("text/html");
	str.data = "SourceURL:" + event.originalTarget.location.href + " " +string;
	trans.setTransferData("text/html",str,string.length * 2);
	
	// Workaround to notify cS of change of clipboard content
	var str2 = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);  
	
	str2.data = string;
	trans.addDataFlavor("text/unicode");  
	trans.setTransferData("text/unicode", str2, string.length * 2);
	// end workaround
	
	clip.setData(trans,null,clipid.kGlobalClipboard);
}

function cshelper_pageLoad(event_pageload) {
	
	var document = event_pageload.target;
	var href = document.location.href;
	
	// is this a ogame site ?
	if (document.location.href.search("/game/index.php") <= -1) {
		return; // exit if no ogame site
	} 
	
	if (!cshelper.BrowserOverlay.isHelperActiveFor(document)) {
		cshelper_myTestLog(document, 'cSHelper disabled <br> for this universe!');
		return;
	}
	
	if (typeof(cshelper.BrowserOverlay.active) != "undefined" 
			&& !cshelper.BrowserOverlay.active) {
		cshelper_myTestLog(document, 'cSHelper disabled!');
		return;
	}
	
	var inhalt_ajax_handler_galaxy = function (event) 
				{
					if (event.target.id == "galaxytable")
					{
						if (cshelper.BrowserOverlay.doWeUseTCP(document)) {
							cshelper.BrowserOverlay.sendHTML_To_cS_TCPIP(document.body.innerHTML, event_pageload, document);
						} else {
							copyToClipboard(document.body.innerHTML, event_pageload, document);
						}
						//cshelper_myTestLog(document, 'COPY SUCCESS');			
					}
				
				};

	var inhalt_ajax_handler_stats = function (event) 
				{
					if (event.target.className == "content")
					{	
						if (cshelper.BrowserOverlay.sendTCPIP) {
							cshelper.BrowserOverlay.sendHTML_To_cS_TCPIP(document.body.innerHTML, event_pageload, document);
						} else {
							copyToClipboard2(document.body.innerHTML, event_pageload, document);
						}
						//cshelper_myTestLog(document, 'COPY SUCCESS');			
					}
				
				};

	var inhalt_ajax_handler_msgs = function (event) 
				{
					if (event.target.tagName == "FORM")
					{	
						if (cshelper.BrowserOverlay.sendTCPIP) {
							cshelper.BrowserOverlay.sendHTML_To_cS_TCPIP(document.body.innerHTML, event_pageload, document);
						} else {
							copyToClipboard(document.body.innerHTML, event_pageload, document);
						}
						//cshelper_myTestLog(document, 'COPY SUCCESS');			
					}
				
				};
	
	cshelper_myTestLog(document, 'cSHelper active!');
	
	if ((document.location.href.search("page=messages") > -1)) {
		var inhalt = document.getElementById('netz'); 
		inhalt.addEventListener("DOMNodeInserted", inhalt_ajax_handler_msgs, true);
		cshelper_myTestLog(document, 'Messages detected!');
	}
	
	else if ((document.location.href.search("page=statistics") > -1)) {
		var inhalt = document.getElementById('inhalt'); 
		inhalt.addEventListener("DOMNodeInserted", inhalt_ajax_handler_stats, true);
		cshelper_myTestLog(document, 'Statistics detected!');
	}
	
	else if ((document.location.href.search("page=galaxy") > -1))
	{
		var inhalt = document.getElementById('inhalt'); 
		inhalt.addEventListener("DOMNodeInserted", inhalt_ajax_handler_galaxy, true);
		cshelper_myTestLog(document, 'Galaxy detected!');
	}
}

window.addEventListener('DOMContentLoaded', cshelper_pageLoad, true);