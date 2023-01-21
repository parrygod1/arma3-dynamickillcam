params["_unit"];
_unit setUnconscious true;
[_unit] spawn {
	params["_unit"];
	sleep NER_antiWallGlitch_unconsciousHelperSleepTime;
	waitUntil{speed _unit <= 1};
	_unit setUnconscious false;
};