params["_unit"];
private _force = NER_antiWallGlitch_punishByTeleport_strength;
private _oppositeVelocity = vectorNormalized ( (velocity _unit) vectorMultiply -1);
private _oppositeVelocityWithForce = _oppositeVelocity vectorMultiply _force;

_unit setPos ((getPos _unit) vectorAdd _oppositeVelocityWithForce);