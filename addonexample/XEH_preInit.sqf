private _fName = "ner_antiwallglitch::XEH_preInit: ";
diag_log format[_fName + "enter"];

["NER_antiWallGlitch_sleepTime", "SLIDER", ["Sleep Time", "Determines how often the script checks for wall glitching. The higher the value, the less frequently the script checks, and the lower the value, the more frequently it checks."], ["Anti Wall Glitch by Nerexis", "1. General"], [0.001, 3, 0.05, 2], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_enabled", "CHECKBOX", ["Enabled", "Enables or disables the anti wall glitch script."], ["Anti Wall Glitch by Nerexis", "1. General"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_isEnabledForPlayers", "CHECKBOX", ["Enabled for Players", "Enables or disables the wall glitch prevention for players."], ["Anti Wall Glitch by Nerexis", "1. General"], [false], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_isEnabledForHiddenObjects", "CHECKBOX", ["Enabled for hidden objects", "Enables or disables the wall glitch prevention for hidden units (sqf hideObject/hideObjectGlobal)."], ["Anti Wall Glitch by Nerexis", "1. General"], [false], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_disableOnPlants", "CHECKBOX", ["Disable on Plants", "Enables or disables the wall glitch prevention when the unit is standing on a plant."], ["Anti Wall Glitch by Nerexis", "1. General"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_disableOnDoors", "CHECKBOX", ["Disable on Doors collision", "Enables or disables the wall glitch prevention when the unit is intersecting with a door."], ["Anti Wall Glitch by Nerexis", "1. General"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_disableNearDoors", "CHECKBOX", ["Disable near Doors", "Enables or disables the wall glitch prevention when the unit is near a door."], ["Anti Wall Glitch by Nerexis", "1. General"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_disableNearDoorsDistance", "SLIDER", ["Disable near Doors distance", "A minimum distance of a unit to door object after which glitch prevention is disabled."], ["Anti Wall Glitch by Nerexis", "1. General"], [0.01, 10, 1.75, 2], 1, {}] call CBA_fnc_addSetting;

["NER_antiWallGlitch_checkHead", "CHECKBOX", ["Check Head", "Enables or disables checking for wall glitching using the unit's head position."], ["Anti Wall Glitch by Nerexis", "2. Position Checking"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_checkWeaponLeft", "CHECKBOX", ["Check Weapon Left", "Enables or disables checking for wall glitching using the unit's left weapon position."], ["Anti Wall Glitch by Nerexis", "2. Position Checking"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_checkWeaponRight", "CHECKBOX", ["Check Weapon Right", "Enables or disables checking for wall glitching using the unit's right weapon position."], ["Anti Wall Glitch by Nerexis", "2. Position Checking"], [true], 1, {}] call CBA_fnc_addSetting;

["NER_antiWallGlitch_distance_weapon_left", "SLIDER", ["Distance Weapon Left", "Determines the maximum distance that the unit's left weapon can be from a solid object before triggering the wall glitch prevention."], ["Anti Wall Glitch by Nerexis", "3. Distance"], [0.01, 1, 0.2, 2], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_distance_weapon_right", "SLIDER", ["Distance Weapon Right", "Determines the maximum distance that the unit's right weapon can be from a solid object before triggering the wall glitch prevention."], ["Anti Wall Glitch by Nerexis", "3. Distance"], [0.01, 1, 0.2, 2], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_distance_head", "SLIDER", ["Distance Head", "Determines the maximum distance that the unit's head can be from a solid object before triggering the wall glitch prevention."], ["Anti Wall Glitch by Nerexis", "3. Distance"], [0.01, 1, 0.1, 2], 1, {}] call CBA_fnc_addSetting;

["NER_antiWallGlitch_punishType", "LIST",
["Punishment Type", "Determines the type of punishment to be applied when a wall glitch is detected."],
["Anti Wall Glitch by Nerexis", "4. Punishment"],
[
	[1,2,3,4,5,6,7,8],
	[
		"Ragdoll/unconscious state",
		"Adding opposite force",
		"Teleport to opposite direction",
		"Add opposite velocity",
		"Reset velocity and movement",
		"Teleport to opposite dir with added jump",
		"Reset velocity with added jump",
		"Teleport to opposite dir with added FORWARD jump"
	],
	1
]
, 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_punishByForce_strength", "SLIDER", ["Punishment by Force Strength", "Determines the strength of the force applied when punishment type is set to 'Add Force'."], ["Anti Wall Glitch by Nerexis", "4. Punishment"], [50, 1000, 150, 0], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_punishByTeleport_strength", "SLIDER", ["Punishment by Teleport Strength", "Determines the strength of the teleport applied when punishment type is set to 'Teleport Opposite Vector' or 'Teleport Opposite Dir with Jump' or 'Teleport Opposite Dir with FORWARD Jump'."], ["Anti Wall Glitch by Nerexis", "4. Punishment"], [0.0001, 1, 0.001, 4], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_punishByTeleport_jumpStrength", "SLIDER", ["Punishment by Teleport Jump Strength", "Determines the jump strength applied when punishment type is set to 'Teleport Opposite Dir with Jump' or 'Teleport Opposite Dir with FORWARD Jump'."], ["Anti Wall Glitch by Nerexis", "4. Punishment"], [0, 15, 2.5, 2], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_punishByNullVelocity_jumpStrength", "SLIDER", ["Punishment by Null Velocity Jump Strength", "Determines the jump strength applied when punishment type is set to 'Velocity and Movement Reset' or 'Reset Velocity with Jump'."], ["Anti Wall Glitch by Nerexis", "4. Punishment"], [0, 30, 5, 2], 1, {}] call CBA_fnc_addSetting;

/*["NER_antiWallGlitch_plantsModelNames", "EDITBOX", ["Plant Model Names", "A list of model names for plants that the wall glitch prevention should be disabled on. Separate each model name with a comma."], ["Anti Wall Glitch by Nerexis", "5. Plants"], [], 1, {}] call CBA_fnc_addSetting;*/

["NER_antiWallGlitch_recalcPathPlanningAtBadLoc", "CHECKBOX", ["Recalculate unit Path Planning at Bad Location", "Enables or disables the recalculation of the unit's path planning when a wall glitch is detected."], ["Anti Wall Glitch by Nerexis", "5. Path Planning"], [true], 1, {}] call CBA_fnc_addSetting;

["NER_antiWallGlitch_createBarrierAtBadLocation", "CHECKBOX", ["Create Barrier at Bad Location", "Enables or disables the creation of a barrier at the location where a wall glitch is detected."], ["Anti Wall Glitch by Nerexis", "6. Barrier"], [false], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_barrierClass", "EDITBOX", ["Barrier Class", "The class name of the barrier object to be created at the location where a wall glitch is detected."], ["Anti Wall Glitch by Nerexis", "6. Barrier"], ["Land_BarrelEmpty_F"], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_barrierDistance", "SLIDER", ["Barrier Distance", "Determines the distance of the barrier from the unit's position where a wall glitch is detected."], ["Anti Wall Glitch by Nerexis", "6. Barrier"], [0.1, 5, 1.2, 2], 1, {}] call CBA_fnc_addSetting;

["NER_antiWallGlitch_unconsciousHelperSleepTime", "SLIDER", ["Unconscious Helper Sleep Time", "The time in seconds to wait before checking for unconscious units to revive them."], ["Anti Wall Glitch by Nerexis", "7. Unconscious"], [0, 60, 2, 2], 1, {}] call CBA_fnc_addSetting;

["NER_antiWallGlitch_preventDeathOnPunish", "CHECKBOX", ["Prevent Death on Punish", "Enables or disables preventing death of units punished by script."], ["Anti Wall Glitch by Nerexis", "8. Death Prevention"], [true], 1, {}] call CBA_fnc_addSetting;
["NER_antiWallGlitch_preventDeathTime", "SLIDER", ["Prevent Death Time", "The time in seconds for how long death prevention is enabled."], ["Anti Wall Glitch by Nerexis", "8. Death Prevention"], [0, 10, 2, 2], 1, {}] call CBA_fnc_addSetting;


diag_log format[_fName + "CBA settings loaded"];
diag_log format[_fName + "exit"];