killCamChance = 0.07;
playerCamChance = 0.4;
trackedUnits = [];

getHeight = {
	_unit = _this select 0;

	switch (stance _unit) do {
		case "STAND": {
			-0.2
		};
		case "CROUCH": {
			-0.5
		};
		case "PRONE": {
			-0.35
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
	_camera = _this select 0;

	sleep 0.5;
	setAccTime 1;
	_camera cameraEffect ["terminate", "back"];
	camDestroy _camera;
};

setUnitCamera = {
	_unit = _this select 0;
	_camera = _this select 1;

	height = [_unit] call getHeight;
	private _headInModel = _unit selectionPosition "head";
	private _headInMap = _unit modelToWorld _headInModel;
	private _yDistance = random [-4, 2, 4];
	private _zDistance = random [0, height, height];
	private _xDistance = random [-3, 1, 3];

	_camera camPrepareTarget _headInMap;
	_camera camPrepareFov random [0.2, 0.4, 0.5];
	_camera camCommitPrepared 0;
	_camera camPrepareRelPos [_xDistance, _yDistance, _zDistance];
	_camera cameraEffect ["external", "back"];
	_camera camCommitPrepared 0;
};

spawnUnitCamera = {
	_unit = _this select 0;

	_camera = "camera" camCreate getPosATL _unit;
	_accTime = random [0.1, 0.2, 0.3];
	[_unit, _camera] call setUnitCamera;
	setAccTime _accTime;
	[_camera] call exitCamera;
};

runCameraSequence = {
	_enemy = _this select 1;
	_instigator = _this select 0;

	[_instigator, _enemy] spawn {
		sleep 0.2;
		if ([killCamChance] call willSpawn) then {
			[_this select 1] call spawnUnitCamera;
			if ([playerCamChance] call willSpawn) then {
				[_this select 0] call spawnUnitCamera;
			}
		};
	};
};

(vehicle player) addEventHandler ["Fired", {
	_weapon = _this select 1;
	_type = getNumber (configfile >> "CfgWeapons" >> _weapon >> "type");// 0-thrown, 1-rifle 2-pistol 3-? 4-launcher
	_projectile = _this select 6;

	_projectile addEventHandler ["HitPart", {
		_hitEntity = _this select 1;

		if (true) then {
			trackedUnits append [_hitEntity];

			_hitEntity addEventHandler ["Killed", {
				_enemy = _this select 0;

				if (!((side group _enemy) isEqualTo (side group player))) then {
					[player, _enemy] call runCameraSequence;
				};
			}];
		}
	}];
}];