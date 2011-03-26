
// read pref with default value
function rPD_int(bra, pref, aDefault) {
	if (bra.prefHasUserValue(pref)) {
		return bra.getIntPref(pref);
	} else {
		return aDefault;
	}
}

function rPD_bool(bra, pref, aDefault) {
	if (bra.prefHasUserValue(pref)) {
		return bra.getBoolPref(pref);
	} else {
		return aDefault;
	}
}

function rPD_string(bra, pref, aDefault) {
	if (bra.prefHasUserValue(pref)) {
		return bra.getStringPref(pref);
	} else {
		return aDefault;
	}
}

function getSelectedUniUrl() {
	
	var list = document.getElementById("uni_url_list");
	var item = list.selectedItem;
	return item.value;
	
}

var list_count = 0;

function getUniPerfBranch(uni_url) {
	const Cc = Components.classes;
	const Ci = Components.interfaces; 
	
	return Cc["@mozilla.org/preferences-service;1"]
		.getService(Components.interfaces.nsIPrefService)
			.getBranch("cshelper.host." + uni_url + ".");
}

var onActivateClick = function(event) {
	
	const Cc = Components.classes;
	const Ci = Components.interfaces; 
	
	var uni_url = getSelectedUniUrl();
	
	var uni_pref = Cc["@mozilla.org/preferences-service;1"]
		.getService(Components.interfaces.nsIPrefService)
			.getBranch("cshelper.hostlist.");
	
	uni_pref.setBoolPref(uni_url, !rPD_bool(uni_pref, uni_url, true));
	reset();
	
}
var onChangePortClick = function(event) {
	
	var uni_url = getSelectedUniUrl();
	var uni_pref = getUniPerfBranch(getSelectedUniUrl());
	var port = { value: rPD_int(uni_pref, "port", 32432) };
	
	var promptService = Components.classes["@mozilla.org/embedcomp/prompt-service;1"]
		.getService(Components.interfaces.nsIPromptService);
	
	var b = {};
	promptService.prompt(null, "Ändern des Ports für: " + uni_url, 
		"Für welchen Port wurde cS konfiguriert?", port, null, b);
	
	uni_pref.setIntPref("port", port.value);
	
	reset();
	
}
var onChangeTypeClick = function(event) {
	
	var uni_url = getSelectedUniUrl();
	var uni_pref = getUniPerfBranch(getSelectedUniUrl());
	var port = rPD_int(uni_pref, "port", 32432);
	
	var promptService = Components.classes["@mozilla.org/embedcomp/prompt-service;1"]
		.getService(Components.interfaces.nsIPromptService);
	
	if (port > 0) {
		uni_pref.setIntPref("port", -1);
		reset();
	} else {
		onChangePortClick();
	}
	
}

function reset() {
	
	var list = document.getElementById("uni_url_list");
	for (var i = 0; i < list_count; i++) {
		list.removeChild(list.lastElementChild);
	}
	
	onLoad();
	
}

function onLoad() {
	
	var list = document.getElementById("uni_url_list");
	
	const Cc = Components.classes;
	const Ci = Components.interfaces; 
	
	var unis = Cc["@mozilla.org/preferences-service;1"]
		.getService(Components.interfaces.nsIPrefService)
			.getBranch("cshelper.hostlist.");
	
	// sets count.value = count;
	var count = {};
	var childs = unis.getChildList("", count);
	list_count = count.value;
	
	for (var i = 0; i < count.value; i++)
	{
		var row = document.createElement('listitem');
		row.setAttribute("value", childs[i]);
		var cell = document.createElement('listcell');
		cell.setAttribute('label', childs[i]);
		row.appendChild(cell);
		
		var uni_prefs = Cc["@mozilla.org/preferences-service;1"]
			.getService(Components.interfaces.nsIPrefService)
				.getBranch("cshelper.host." + childs[i] + ".");
		
		var port = rPD_int(uni_prefs,"port",-1);
		var type = "clipb";
		if (port > 0) {
			type = "TCP";
		}
		
		cell = document.createElement('listcell');
		cell.setAttribute('label', rPD_bool(unis,childs[i],true));
		row.appendChild(cell);
		
		cell = document.createElement('listcell');
		cell.setAttribute('label', type);
		row.appendChild(cell);
		
		cell = document.createElement('listcell');
		cell.setAttribute('label', port);
		row.appendChild(cell);
		
		list.appendChild(row);
	}
	
}
