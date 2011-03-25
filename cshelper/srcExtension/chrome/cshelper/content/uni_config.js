
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

function onLoad() {
	
	var list = document.getElementById("uni_url_list");
	
	const Cc = Components.classes;
	const Ci = Components.interfaces; 
	
	var unis = Cc["@mozilla.org/preferences-service;1"]
		.getService(Components.interfaces.nsIPrefService)
			.getBranch("cshelper.hostlist.");
	
	var count = {};
	var childs = unis.getChildList("", count);
	
	for (var i = 0; i < count.value; i++)
	{
		var row = document.createElement('listitem');
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
