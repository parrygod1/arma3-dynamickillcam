params["_unit"];
private _currentDestination = expectedDestination _unit;
if( (_currentDestination # 0) isNotEqualTo [0,0,1e+009]) then {
	doStop _unit;
	_unit doMove (_currentDestination # 0);
};