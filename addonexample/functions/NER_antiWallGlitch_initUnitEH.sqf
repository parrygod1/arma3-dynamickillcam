params["_unit"];
private _fName = format["NER_antiWallGlitch_initUnitEH(%1): ",_this];
diag_log format[_fName + "called"];
if(!(_unit getVariable ["NER_antiWallGlitch_monitorAdded",false])) then {
	_unit setVariable["NER_antiWallGlitch_monitorAdded",true];
	[_unit] spawn NER_antiWallGlitch_checkUnitThread;
};