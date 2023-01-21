params["_unit"];
switch (NER_antiWallGlitch_punishType) do
{
	case 1: { _unit call NER_antiWallGlitch_punishByUnconscious; };
	case 2: { _unit call NER_antiWallGlitch_punishByForce; };
	case 3: { _unit call NER_antiWallGlitch_punishByTeleport; };
	case 4: { _unit call NER_antiWallGlitch_punishByNullVelocity; };

	case 5: { _unit call NER_antiWallGlitch_punishByResetMoveDestination; };
	case 6: { _unit call NER_antiWallGlitch_punishByTeleportAddJump; };
	case 7: { _unit call NER_antiWallGlitch_punishByNullVelocityAddJump; };
	case 8: { _unit call NER_antiWallGlitch_punishByTeleportAddForwardJump; };

	default { systemChat "NER_antiWallGlitch: Unknown punish type set"; };
};