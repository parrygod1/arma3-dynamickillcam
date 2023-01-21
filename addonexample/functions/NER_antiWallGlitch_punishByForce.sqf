params["_unit"];
private _force = NER_antiWallGlitch_punishByForce_strength;
private _oppositeVelocity = vectorNormalized ( (velocity _unit) vectorMultiply -1);

private _oppositeVelocityWithForce = _oppositeVelocity vectorMultiply _force;
_unit addForce [_oppositeVelocityWithForce, [0,0,0] ];

[_unit] spawn {
	params["_unit"];
	sleep NER_antiWallGlitch_unconsciousHelperSleepTime;
	waitUntil{speed _unit <= 1};
	_unit setUnconscious false;
};