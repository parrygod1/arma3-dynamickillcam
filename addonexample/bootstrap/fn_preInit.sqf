private _fName = "NER_antiwallglitch_preInit: ";

diag_log format[_fName + "called"];

systemChat format["Anti Wall glitch script by Nerexis loading..."];

NER_antiWallGlitch_sleepTime = 0.05;

NER_antiWallGlitch_enabled = true;

NER_antiWallGlitch_checkHead = true;
NER_antiWallGlitch_checkWeaponLeft = true;
NER_antiWallGlitch_checkWeaponRight = true;

NER_antiWallGlitch_distance_weapon_left = 0.1;
NER_antiWallGlitch_distance_weapon_right = 0.1;
NER_antiWallGlitch_distance_head = 0.1;

NER_antiWallGlitch_disableOnPlants = true;
NER_antiWallGlitch_plantsModelNames = [];

// Punish types:
// 1 - punish by ragdoll/unconscious state,
// 2 - punish by adding force,
// 3 - punish by teleport to opposite vector,
// 4 - punish by opposite velocity,
// 5 - punish by velocity and movement reset,
// 6 - punish by teleporting to opposite dir with added jump,
// 7 - punish by resetting velocity with added jump,
// 8 - punish by teleport to opposite dir with added FORWARD jump
NER_antiWallGlitch_punishType = 2;

NER_antiWallGlitch_punishByForce_strength = 250;

NER_antiWallGlitch_punishByTeleport_strength = 0.001;
NER_antiWallGlitch_punishByTeleport_jumpStrength = 2;

NER_antiWallGlitch_punishByNullVelocity_jumpStrength = 2.5;

NER_antiWallGlitch_createBarrierAtBadLocation = false;
NER_antiWallGlitch_barrierClass = "Land_InvisibleBarrier_F";
NER_antiWallGlitch_barrierDistance = 1.2;

NER_antiWallGlitch_recalcPathPlanningAtBadLoc = true;

NER_antiWallGlitch_unconsciousHelperSleepTime = 2;

NER_antiWallGlitch_preventDeathOnPunish = true;
NER_antiWallGlitch_preventDeathTime = 2;

NER_antiWallGlitch_isEnabledForPlayers = false;
NER_antiWallGlitch_isEnabledForHiddenObjects = true;

NER_antiWallGlitch_disableOnDoors = true;
NER_antiWallGlitch_disableNearDoors = true;
NER_antiWallGlitch_disableNearDoorsDistance = 1;

NER_antiWallGlitch_checkGeom = "FIRE"; // PHYSX better?
NER_antiWallGlitch_checkMaxResultsCount = 3;

private _pathPrefix = "ner_antiwallglitch\functions\";
diag_log format[_fName + "path prefix: %1" , _pathPrefix];
{
	private _path = (_pathPrefix + (_x select 0) + ".sqf");
	diag_log format[_fName + "compiling %1, path %2", _x select 0, _path];
	private _code = compile (preprocessFileLineNumbers _path);
	missionNamespace setVariable [(_x select 0), _code];
}
forEach
[
	['NER_antiWallGlitch_checkUnit'],
	['NER_antiWallGlitch_checkUnitThread'],
	['NER_antiWallGlitch_createBarrier'],
	['NER_antiWallGlitch_handleUnitGlitchingEvent'],
	['NER_antiWallGlitch_isUnitGlitching'],
	['NER_antiWallGlitch_punishByForce'],
	['NER_antiWallGlitch_punishByNullVelocity'],
	['NER_antiWallGlitch_punishByNullVelocityAddJump'],
	['NER_antiWallGlitch_punishByResetMoveDestination'],
	['NER_antiWallGlitch_punishByTeleport'],
	['NER_antiWallGlitch_punishByTeleportAddForwardJump'],
	['NER_antiWallGlitch_punishByTeleportAddJump'],
	['NER_antiWallGlitch_punishByUnconscious'],
	['NER_antiWallGlitch_punishUnit'],
	['NER_antiWallGlitch_recalcPathToDestination'],
	['NER_antiWallGlitch_initUnitEH'],
	['NER_antiWallGlitch_extractPlantModelNames'],
	['NER_antiWallGlitch_getObjDoorsModelPos'],
	['NER_antiWallGlitch_getObjDoorsWorldPos'],
	['NER_antiWallGlitch_isObjDoorNearToPos'],
	['NER_antiWallGlitch_isObjPlant']
];

diag_log format[_fName + "extracting plant models"];
NER_antiWallGlitch_plantsModelNames = call NER_antiWallGlitch_extractPlantModelNames;
diag_log format[_fName + "plant models found count: %1",count NER_antiWallGlitch_plantsModelNames];

systemChat format["Anti Wall Glitch script by Nerexis loaded"];
diag_log format[_fName + "exit"];