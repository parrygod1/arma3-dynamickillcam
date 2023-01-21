params["_unit"];

private _preventDeathInvoked = false;
if(NER_antiWallGlitch_preventDeathOnPunish && isDamageAllowed _unit) then {
	_unit allowDamage false;
	_preventDeathInvoked = true;
};
_unit call NER_antiWallGlitch_punishUnit;

if(NER_antiWallGlitch_createBarrierAtBadLocation) then {
	_unit call NER_antiWallGlitch_createBarrier;
};

if(_preventDeathInvoked) then {
	if(NER_antiWallGlitch_preventDeathTime ==  0) then {
		_unit allowDamage true;
	} else {
		[_unit] spawn {
			params["_unit"];
			sleep NER_antiWallGlitch_preventDeathTime;
			_unit allowDamage true;
		};
	};

};

if(!isPlayer _unit && NER_antiWallGlitch_recalcPathPlanningAtBadLoc) then {
	_unit call NER_antiWallGlitch_recalcPathToDestination;
};
