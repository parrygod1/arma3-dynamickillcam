private _fName = "NER_antiWallGlitch_extractPlantModelNames: ";
private _fStartTime = diag_tickTime;
diag_log format[_fName + "enter, start time: %1",_fStartTime];
private _plantObjModels = [];
private _plantsCategories = [
	"TREE",
	"SMALL TREE",
	"BUSH",
	"FOREST BORDER",
	"FOREST TRIANGLE",
	"FOREST SQUARE",
	"FOREST"
];

private _plantsObjs = nearestTerrainObjects
[
	[worldSize / 2, worldSize / 2],
	_plantsCategories,
	worldSize * sqrt 2 / 2,
	true
];


{
	_plantObjModels pushBackUnique ((getModelInfo _x) select 0);
} forEach _plantsObjs;

diag_log format[_fName + "exit, took %1",diag_tickTime - _fStartTime];

_plantObjModels;