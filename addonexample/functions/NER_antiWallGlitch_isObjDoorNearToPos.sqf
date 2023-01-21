params["_obj",["_pos",[],[]]];

private _objDoorsPos = _obj call NER_antiWallGlitch_getObjDoorsWorldPos;
(_objDoorsPos findIf { _pos distance _x < NER_antiWallGlitch_disableNearDoorsDistance; }) != -1;