params["_unit"];
private _barrierPos = _unit getRelPos [NER_antiWallGlitch_barrierDistance, 0];
private _barrier = NER_antiWallGlitch_barrierClass createVehicle _barrierPos;
_barrier enableSimulation false;
_barrier enableSimulationGlobal false;