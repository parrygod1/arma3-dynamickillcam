playerCamChance = 0;
par_dynamickillcam_trackedUnits = [];// used to prevent stacking event handlers
par_dynamickillcam_isInCamera = false;

PPeffect_colorC = ppEffectCreate ["ColorCorrections", 1500];
PPeffect_colorC ppEffectAdjust [1.0171, 1.11041, 0.0404295, [0, 0, 0, 0.00543666], [0.80244, 1.10571, 0.919084, 0.959542], [0.69944, -0.161832, 0.462392, 0]];
PPeffect_grain = ppEffectCreate ["FilmGrain", 1550];
PPeffect_grain ppEffectAdjust [0.0668329, 0.5, 0, 0.2, 0.1];

par_dynamickillcam_soundNames = ["par_dynamickillcam_slow1", "par_dynamickillcam_slow2", "par_dynamickillcam_slow3"];

getPreset = {
	_type = _this select 0;

	if (_type == "FREE") exitWith {
		[
			"#UP1",
			[
				"&Y", -7,
				"&X", 5,
				"&Z", 4,
				"&FOV", 0.1
			],
			"#UP2",
			[
				"&Y", -6,
				"&X", 5,
				"&Z", 5,
				"&FOV", 0.1
			],
			"#DOWN1",
			[
				"&Y", 7,
				"&X", -5,
				"&Z", 0.2,
				"&FOV", 0.1
			],
			"#DOWN2",
			[
				"&Y", -6,
				"&X", 6,
				"&Z", 0.2,
				"&FOV", 0.1
			],
			"#LEVEL1",
			[
				"&Y", 7,
				"&X", -5,
				"&Z", 1,
				"&FOV", 0.1
			],
			"#LEVEL2",
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
	par_dynamickillcam_isInCamera = false;
	player allowDamage true;

	PPeffect_colorC ppEffectEnable false;
	PPeffect_grain ppEffectEnable false;
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

	height = [_unit] call getHeight;
	private _partInModel = _unit selectionPosition _part;
	private _partInMap = _unit modelToWorld _partInModel;
	private _target = _partInMap vectorAdd (eyeDirection _unit vectorMultiply 0.2);

	_camera camPrepareTarget _target;
	_camera camPrepareFov ([_presetName, _presetArray] call getCameraFovValue);
	_camera camCommitPrepared 0;
	_camera camPrepareRelPos ([_presetName, _presetArray, _unit] call getCameraPosValues);
	_camera camCommitPrepared 0;
	_camera cameraEffect ["external", "back"];
	if (par_dynamickillcam_enableNVG && sunOrMoon < 1) then {
		camUseNVG true;
	};
};

playEffects = {
	private _camera = _this select 0;

	// if (par_dynamickillcam_enablePP) then {
		// PPeffect_colorC ppEffectEnable true;
		// PPeffect_grain ppEffectEnable true;
		// PPeffect_colorC ppEffectCommit 0;
		// PPeffect_grain ppEffectCommit 0;
		//
	//};

	if (par_dynamickillcam_enableSound) then {
		private _sound = selectRandom par_dynamickillcam_soundNames;
		playSound [_sound, false, 0.2];
	};
};

handleLetterBox = {
	if (par_dynamickillcam_enableLetterBox) then {
		showCinemaBorder true;
	} else {
		showCinemaBorder false;
	};
};

// Refactor this function
setUnitCamera = {
	private _unit = _this select 0;
	private _camera = _this select 1;

	[_camera, _unit] call updateCameraValues;

	if ([_camera, _unit] call getIsVisible) then {
		call handleLetterBox;
		par_dynamickillcam_isInCamera = true;
		[_camera] call playEffects;
	} else {
		// try again
		[_camera, _unit] call updateCameraValues;
		if ([_camera, _unit] call getIsVisible) then {
			call handleLetterBox;
			par_dynamickillcam_isInCamera = true;
			[_camera] call playEffects;
		} else {
			_camera cameraEffect ["terminate", "back"];
			par_dynamickillcam_isInCamera = false;
			camDestroy _camera;
		}
	};
};

spawnUnitCamera = {
	private _unit = _this select 0;
	private _camera = "camera" camCreate getPosATL _unit;

	try {
		[_unit, _camera] call setUnitCamera;

		if (par_dynamickillcam_isInCamera) then {
			player allowDamage false;
			setAccTime 0.2;
			[_camera] call exitCamera;
		} else {
			camDestroy _camera;
		};
	} catch {
		diag_log _exception;
		_camera cameraEffect ["terminate", "back"];
		par_dynamickillcam_isInCamera = false;
		camDestroy _camera;
	};
};

runCameraSequence = {
	private _enemy = _this select 1;
	private _instigator = _this select 0;

	[_instigator, _enemy] spawn {
		sleep 0.14;

		if ([par_dynamickillcam_killCamChance] call willSpawn) then {
			[_this select 1] call spawnUnitCamera;

			if ([playerCamChance] call willSpawn) then {
				[_this select 0] call spawnUnitCamera;
			};
		};
	};
};

if (isDedicated == false) then {
	(vehicle player) addEventHandler ["Fired", {
		// private _weapon = _this select 1;
		// private _type = getNumber (configfile >> "CfgWeapons" >> _weapon >> "type");// 0-thrown, 1-rifle 2-pistol 3-? 4-launcher
		private _projectile = _this select 6;

		_projectile addEventHandler ["HitPart", {
			private _hitEntity = _this select 1;

			if (vehicle _hitEntity isKindOf "Man" && !(_hitEntity in par_dynamickillcam_trackedUnits)) then {
				par_dynamickillcam_trackedUnits append [_hitEntity];

				_hitEntity addEventHandler ["Killed", {
					private _enemy = _this select 0;

					if (!((side group _enemy) isEqualTo (side group player)) && !par_dynamickillcam_isInCamera) then {
						[player, _enemy] call runCameraSequence;
					};

					par_dynamickillcam_trackedUnits = par_dynamickillcam_trackedUnits - [_enemy];
				}];

				_hitEntity addEventHandler ["Deleted", {
					par_dynamickillcam_trackedUnits = par_dynamickillcam_trackedUnits - [_this select 0];
				}];
			};
		}];
	}];
};