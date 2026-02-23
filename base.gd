extends Node2D

var SpawnFunctions = BaseSpawn.new();
func _ready() -> void:
	SpawnFunctions.Spawn("BasePlayer", Vector2(0,0), self)
	
	SpawnFunctions.SpawnWave(1, [Vector2(200,400), Vector2(100,-100), Vector2(200,0), Vector2(100,300)], self)
	return;
