function cshelper_myTestLog(document, msg) {
	var log = document.getElementById('playerName');
	log.innerHTML += '<br>'+msg;
}

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

function cshelper_pageLoad(event_pageload)	{
	var document = event_pageload.target;
	var href = document.location.href;
	
	var inhalt_ajax_handler_galaxy = function (event) 
				{
					if (event.target.id == "galaxytable")
					{	
						copyToClipboard(document.body.innerHTML, event_pageload, document);
						//cshelper_myTestLog(document, 'COPY SUCCESS');			
					}
				
				};

	var inhalt_ajax_handler_stats = function (event) 
				{
					if (event.target.className == "content")
					{	
						copyToClipboard2(document.body.innerHTML, event_pageload, document);
						//cshelper_myTestLog(document, 'COPY SUCCESS');			
					}
				
				};

	var inhalt_ajax_handler_msgs = function (event) 
				{
					if (event.target.tagName == "FORM")
					{	
						copyToClipboard(document.body.innerHTML, event_pageload, document);
						//cshelper_myTestLog(document, 'COPY SUCCESS');			
					}
				
				};
	
	cshelper_myTestLog(document, 'cSHelper active!');
	
	if ((document.location.href.search("/game/index.php") > -1) && (document.location.href.search("page=messages") > -1)) {
		var inhalt = document.getElementById('netz'); 
		inhalt.addEventListener("DOMNodeInserted", inhalt_ajax_handler_msgs, true);
		cshelper_myTestLog(document, 'Messages detected!');
	}
	
	else if ((document.location.href.search("/game/index.php") > -1) && (document.location.href.search("page=statistics") > -1)) {
		var inhalt = document.getElementById('inhalt'); 
		inhalt.addEventListener("DOMNodeInserted", inhalt_ajax_handler_stats, true);
		cshelper_myTestLog(document, 'Statistics detected!');
	}
	
	else if ((document.location.href.search("/game/index.php") > -1) && (document.location.href.search("page=galaxy") > -1))
	{
		var inhalt = document.getElementById('inhalt'); 
		inhalt.addEventListener("DOMNodeInserted", inhalt_ajax_handler_galaxy, true);
		cshelper_myTestLog(document, 'Galaxy detected!');
	}
}

window.addEventListener('DOMContentLoaded', cshelper_pageLoad, true);
