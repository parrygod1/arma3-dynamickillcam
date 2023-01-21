params["_obj"];
private _doorSelectionNames = (selectionNames _obj) select { _x find "door" != -1 };
private _doorPos = _doorSelectionNames apply {
	_obj selectionPosition [_x, "ViewGeometry", "AveragePoint"];
};
_doorPos = _doorPos select { _x isNotEqualTo [0,0,0]; };
_doorPos;