params["_unit"];

while{NER_antiWallGlitch_enabled} do {
	sleep NER_antiWallGlitch_sleepTime;
	if(!local _unit) then { continue; };
	if(!NER_antiWallGlitch_isEnabledForPlayers && isPlayer _unit) then { continue; };
	if(!NER_antiWallGlitch_isEnabledForHiddenObjects && isObjectHidden _unit) then { continue; };
	_unit call NER_antiWallGlitch_checkUnit;
};