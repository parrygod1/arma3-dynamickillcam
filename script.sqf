killCamChance = 1;// 0.07
playerCamChance = 0.2;
trackedUnits = [];// used to prevent stacking event handlers
isInCamera = false;

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
	showCinemaBorder true;
	isInCamera = false;
};

setUnitCamera = {
	_unit = _this select 0;
	_camera = _this select 1;

	height = [_unit] call getHeight;
	private _partInModel = _unit selectionPosition "neck";
	private _partInMap = _unit modelToWorld _partInModel;
	private _yDistance = random [-7, 2, 7];
	private _zDistance = random [height, height + 1, height + 4];
	private _xDistance = random [-5, 1, 5];

	_camera camPrepareTarget _partInMap;
	_camera camPrepareFov random [0.1, 0.2, 0.3];
	_camera camCommitPrepared 0;
	_camera camPrepareRelPos [_xDistance, _yDistance, _zDistance];
	_camera cameraEffect ["external", "back"];
	showCinemaBorder false;
	_camera camCommitPrepared 0;
	isInCamera = true;
};

spawnUnitCamera = {
	_unit = _this select 0;

	_camera = "camera" camCreate getPosATL _unit;
	_accTime = random [0.1, 0.2, 0.3];
	[_unit, _camera] call setUnitCamera;
	setAccTime 0.2;
	[_camera] call exitCamera;
};

runCameraSequence = {
	_enemy = _this select 1;
	_instigator = _this select 0;

	[_instigator, _enemy] spawn {
		sleep 0.14;
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

		if (vehicle _hitEntity isKindOf "Man" && !(_hitEntity in trackedUnits)) then {
			trackedUnits append [_hitEntity];

			_hitEntity addEventHandler ["Killed", {
				_enemy = _this select 0;

				if (!((side group _enemy) isEqualTo (side group player)) && !isInCamera) then {
					[player, _enemy] call runCameraSequence;
				};
			}];
		};
	}];
}];