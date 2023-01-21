params["_obj"];
private _objectId = str _obj;

private _splitStr = ([_objectId, " "] call BIS_fnc_splitstring);

private _modelName = "";
private _countSplitStr = count _splitStr;

if(_countSplitStr <= 0) then {
	continueWith false;
};

if(_countSplitStr == 1) then {
	_modelName = (_splitStr select 0);
};

if(_countSplitStr > 1) then {
	_modelName = (_splitStr select 1);
};

if(isNil "_modelName") then {
	continueWith false;
};

if(_modelName isEqualTo "") then {
	continueWith false;
};

_modelName in NER_antiWallGlitch_plantsModelNames;