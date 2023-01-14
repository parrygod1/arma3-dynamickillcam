killCamChance = 1;
playerCamChance = 0;
trackedUnits = [];// used to prevent stacking event handlers
isInCamera = false;

cameraPresets = [
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
		"&Z", 0,
		"&FOV", 0.1
	],
	"#DOWN2",
	[
		"&Y", -6,
		"&X", 6,
		"&Z", -0.1,
		"&FOV", 0.1
	]
];

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
	private _unit = _this select 1;

	_height = [_unit] call getHeight;
	private _xDistance = [cameraPresets, [_presetName, "x"], 0] call BIS_fnc_dbValueReturn;
	private _yDistance = [cameraPresets, [_presetName, "y"], 0] call BIS_fnc_dbValueReturn;
	private _zDistance = ([cameraPresets, [_presetName, "z"], 0] call BIS_fnc_dbValueReturn) + _height;

	[_xDistance, _yDistance, _zDistance];
};

getCameraFovValue = {
	private _presetName = _this select 0;
	private _fov = [cameraPresets, [_presetName, "fov"], 1] call BIS_fnc_dbValueReturn;

	_fov;
};

updateCameraValues = {
	private _camera = _this select 0;
	private _unit = _this select 1;

	private _presetName = selectRandom ([cameraPresets, []] call BIS_fnc_dbClassList);

	_camera camPrepareFov ([_presetName] call getCameraFovValue);
	_camera camCommitPrepared 0;
	_camera camPrepareRelPos ([_presetName, _unit] call getCameraPosValues);
};

setUnitCamera = {
	private _unit = _this select 0;
	private _camera = _this select 1;
	
	height = [_unit] call getHeight;
	private _partInModel = _unit selectionPosition "body";
	private _partInMap = _unit modelToWorld _partInModel;

	_camera camPrepareTarget _partInMap;
	[_camera, _unit] call updateCameraValues; 
	_camera cameraEffect ["external", "back"];
	showCinemaBorder false;
	_camera camCommitPrepared 0;
	isInCamera = true;
};

spawnUnitCamera = {
	private _unit = _this select 0;
	private _camera = "camera" camCreate getPosATL _unit;

	[_unit, _camera] call setUnitCamera;
	setAccTime 0.2;
	[_camera] call exitCamera;
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