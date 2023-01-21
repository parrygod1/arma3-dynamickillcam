params["_unit"];

private _isGlitching = _unit call NER_antiWallGlitch_isUnitGlitching;
if (_isGlitching && (vehicle _unit == _unit)) then {
	_unit call NER_antiWallGlitch_handleUnitGlitchingEvent;
};
