params["_unit"];

private _isGlitching = false;
private _obstacles = [];

if (NER_antiWallGlitch_checkHead) then {
	_obstacles = lineIntersectsSurfaces [
		[(eyePos _unit select 0) + (eyeDirection _unit select 0)*NER_antiWallGlitch_distance_head, (eyePos _unit select 1) + (eyeDirection _unit select 1)*NER_antiWallGlitch_distance_head, (eyePos _unit select 2) + (eyeDirection _unit select 2)*NER_antiWallGlitch_distance_head],
		eyePos _unit,
		_unit,
		objNull,
		false,
		NER_antiWallGlitch_checkMaxResultsCount,
		NER_antiWallGlitch_checkGeom,
		NER_antiWallGlitch_checkGeom,
		true
	];
	_isGlitching = count _obstacles > 0;
};

if (!_isGlitching && NER_antiWallGlitch_checkWeaponRight) then {
	private _dir_weapon_right = (((_unit weaponDirection currentWeapon _unit) select 0) atan2 ((_unit weaponDirection currentWeapon _unit) select 1))+45;
	_obstacles = [];
	_obstacles = lineIntersectsSurfaces [
		[(eyePos _unit select 0) + NER_antiWallGlitch_distance_weapon_right*sin _dir_weapon_right, (eyePos _unit select 1) + NER_antiWallGlitch_distance_weapon_right*cos _dir_weapon_right, (eyePos _unit select 2)],
		 eyePos _unit,
		_unit,
		objNull,
		false,
		NER_antiWallGlitch_checkMaxResultsCount,
		NER_antiWallGlitch_checkGeom,
		NER_antiWallGlitch_checkGeom,
		true
		];
	_isGlitching = count _obstacles > 0;
};

if (!_isGlitching && NER_antiWallGlitch_checkWeaponLeft) then {
	private _dir_weapon_left = (((_unit weaponDirection currentWeapon _unit) select 0) atan2 ((_unit weaponDirection currentWeapon _unit) select 1))-25;
	_obstacles = [];
	_obstacles = lineIntersectsSurfaces [
		[(eyePos _unit select 0) + NER_antiWallGlitch_distance_weapon_left*sin _dir_weapon_left, (eyePos _unit select 1) + NER_antiWallGlitch_distance_weapon_left*cos _dir_weapon_left, (eyePos _unit select 2)],
		eyePos _unit,
		_unit,
		objNull,
		false,
		NER_antiWallGlitch_checkMaxResultsCount,
		NER_antiWallGlitch_checkGeom,
		NER_antiWallGlitch_checkGeom,
		true
	];
	_isGlitching = count _obstacles > 0;
};

if(_isGlitching && NER_antiWallGlitch_disableOnPlants) then {
	private _isPlant = _obstacles findIf {
		_x params[ "_intersectPosASL", "_surfaceNormal", "_intersectObj", "_parentObject", "_selectionNames", "_pathToBisurf"];
		_intersectObj call NER_antiWallGlitch_isObjPlant;
	} != -1;
	if(_isPlant) then {
		_isGlitching = false;
	};
};

if(_isGlitching && NER_antiWallGlitch_disableOnDoors) then {
	private _allUniqueIntersectedSelections = [];
	{
		_x params[ "_intersectPosASL", "_surfaceNormal", "_intersectObj", "_parentObject", "_selectionNames", "_pathToBisurf"];
		{ _allUniqueIntersectedSelections pushBackUnique _x; } foreach _selectionNames;
	} foreach _obstacles;
	private _isDoor = _allUniqueIntersectedSelections findIf { _x find "door" != -1; } != -1;
	if(_isDoor) then {
		_isGlitching = false;
	};
};

if(_isGlitching && NER_antiWallGlitch_disableNearDoors) then {
	private _isDoor = _obstacles findIf {
		_x params[ "_intersectPosASL", "_surfaceNormal", "_intersectObj", "_parentObject", "_selectionNames", "_pathToBisurf"];
		[_intersectObj, ASLToAGL _intersectPosASL] call NER_antiWallGlitch_isObjDoorNearToPos;
	} != -1;
	if(_isDoor) then {
		_isGlitching = false;
	};
};

_isGlitching;
