killCamChance = 1;
playerCamChance = 0;
trackedUnits = [];// used to prevent stacking event handlers
isInCamera = false;

getPreset = {
	_type = _this select 0;

	if (_type == "FREE") exitWith {
		[
			"#UP1",
			[
				"&Y", 7,
				"&X", 5,
				"&Z", 4,
				"&FOV", 0.1
			],
			"#UP2",
			[
				"&Y", 6,
				"&X", -5,
				"&Z", 5,
				"&FOV", 0.1
			],
			"#DOWN1",
			[
				"&Y", 7,
				"&X", 5,
				"&Z", 0.5,
				"&FOV", 0.1
			],
			"#DOWN2",
			[
				"&Y", -6,
				"&X", 6,
				"&Z", 0.5,
				"&FOV", 0.1
			],
			"#LEVEL1",
			[
				"&Y", 7,
				"&X", 5,
				"&Z", 1,
				"&FOV", 0.1
			],
			"#LEVEL1",
			[
				"&Y", -6,
				"&X", 6,
				"&Z", 1,
				"&FOV", 0.1
			]
		];
	};

	if (_type == "BUILDING") exitWith {
		[
			"#BUILDING1",
			[
				"&Y", -1,
				"&X", 1,
				"&Z", 0,
				"&FOV", 0.5
			],
			"#BUILDING2",
			[
				"&Y", 1,
				"&X", 1,
				"&Z", 1,
				"&FOV", 0.5
			],
			"#BUILDING3",
			[
				"&Y", 0.7,
				"&X", -1,
				"&Z", -0.5,
				"&FOV", 0.5
			]
		];
	};
};

getHeight = {
	private _unit = _this select 0;

	switch (stance _unit) do {
		case "STAND": {
			-0.2
		};
		case "CROUCH": {
			-0.5
		};
		case "PRONE": {
			-0.2
		};
		default {
			-0.2
		};
	};
};

getIsInBuilding = {
	private _unit = _this select 0;
	_intersection = (lineIntersectsSurfaces [eyePos _unit, eyePos _unit vectorAdd [0, 0, 50], _unit, objNull, true, 1]) select 0;

	if (isNil "_intersection") exitWith {
		false;
	};
	true;
};

getIsVisible = {
	private _camera = _this select 0;
	private _unit = _this select 1;

	// _intersection = (lineIntersectsSurfaces [getPosASL _camera, eyePos _unit, _camera, _unit, true, 1]) select 0;
	private _view = [_unit, "VIEW"] checkVisibility [getPosASL _camera, eyePos _unit];

	if (_view >= 0.65) exitWith {
		true
	};
	false;
};

willSpawn = {
	random 1 <= _this select 0;
};

exitCamera = {
	private _camera = _this select 0;

	sleep 0.5;
	setAccTime 1;
	_camera cameraEffect ["terminate", "back"];
	camDestroy _camera;
	showCinemaBorder true;
	isInCamera = false;
};

getCameraPosValues = {
	private _presetName = _this select 0;
	private _presets = _this select 1;
	private _unit = _this select 2;

	_height = [_unit] call getHeight;
	private _xDistance = [_presets, [_presetName, "x"], 0] call BIS_fnc_dbValueReturn;
	private _yDistance = [_presets, [_presetName, "y"], 0] call BIS_fnc_dbValueReturn;
	private _zDistance = ([_presets, [_presetName, "z"], 0] call BIS_fnc_dbValueReturn) + _height;

	[_xDistance, _yDistance, _zDistance];
};

getCameraFovValue = {
	private _presetName = _this select 0;
	private _presets = _this select 1;
	private _fov = [_presets, [_presetName, "fov"], 1] call BIS_fnc_dbValueReturn;

	_fov;
};

updateCameraValues = {
	private _camera = _this select 0;
	private _unit = _this select 1;
	private _part = "spine";
	_presetArray = [];

	if ([_unit] call getIsInBuilding) then {
		_presetArray = ["BUILDING"] call getPreset;
		_part = "spine3";
	} else {
		_presetArray = ["FREE"] call getPreset;
	};

	private _presetName = selectRandom ([_presetArray, []] call BIS_fnc_dbClassList);
	hint str _presetName;

	height = [_unit] call getHeight;
	private _partInModel = _unit selectionPosition _part;
	private _partInMap =  _unit modelToWorld _partInModel;// (ASLToAGL eyePos _unit) vectorAdd (eyeDirection _unit vectorMultiply 0.5); 
	private _target = _partInMap vectorAdd (eyeDirection _unit vectorMultiply 0.2);

	_camera camPrepareTarget _target;
	_camera camPrepareFov ([_presetName, _presetArray] call getCameraFovValue);
	_camera camCommitPrepared 0;
	_camera camPrepareRelPos ([_presetName, _presetArray, _unit] call getCameraPosValues);
	_camera camCommitPrepared 0;
	_camera cameraEffect ["external", "back"];
};

setUnitCamera = {
	private _unit = _this select 0;
	private _camera = _this select 1;

	[_camera, _unit] call updateCameraValues;

	if ([_camera, _unit] call getIsVisible) then {
		showCinemaBorder false;
		isInCamera = true;
	} else {
		// try again
		[_camera, _unit] call updateCameraValues;
		if ([_camera, _unit] call getIsVisible) then {
			showCinemaBorder false;
			isInCamera = true;
		} else {
			_camera cameraEffect ["terminate", "back"];
			isInCamera = false;
			camDestroy _camera;
		}
	};
};

spawnUnitCamera = {
	private _unit = _this select 0;
	private _camera = "camera" camCreate getPosATL _unit;

	try {
		[_unit, _camera] call setUnitCamera;

		if (isInCamera) then {
			setAccTime 0.2;
			[_camera] call exitCamera;
		} else {
			camDestroy _camera;
		};
	} catch {
		_camera cameraEffect ["terminate", "back"];
		isInCamera = false;
		camDestroy _camera;
	};
};

runCameraSequence = {
	private _enemy = _this select 1;
	private _instigator = _this select 0;

	[_instigator, _enemy] spawn {
		sleep 0.14;

		if ([killCamChance] call willSpawn) then {
			[_this select 1] call spawnUnitCamera;
			if ([playerCamChance] call willSpawn) then {
				[_this select 0] call spawnUnitCamera;
			};
		};
	};
};

(vehicle player) addEventHandler ["Fired", {
	private _weapon = _this select 1;
	private _type = getNumber (configfile >> "CfgWeapons" >> _weapon >> "type");// 0-thrown, 1-rifle 2-pistol 3-? 4-launcher
	private _projectile = _this select 6;

	_projectile addEventHandler ["HitPart", {
		private _hitEntity = _this select 1;

		if (vehicle _hitEntity isKindOf "Man" && !(_hitEntity in trackedUnits)) then {
			trackedUnits append [_hitEntity];

			_hitEntity addEventHandler ["Killed", {
				private _enemy = _this select 0;

				if (!((side group _enemy) isEqualTo (side group player)) && !isInCamera) then {
					[player, _enemy] call runCameraSequence;
				};
			}];
		};
	}];
}];