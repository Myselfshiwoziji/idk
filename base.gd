extends Node2D

var SpawnFunctions = BaseSpawn.new();
@export var MapRule : MapRules;

var PlayerSpawnpoint : Vector2 = Vector2.ZERO;
var EnemySpawnpoints : Array[Vector2] = [];
@onready var Spawnpoints : Node2D = $Spawnpoints;
func _ready() -> void:
	InitSpawnpoints();
	SpawnFunctions.Spawn("BasePlayer", PlayerSpawnpoint, self)
	
	if (MapRule.SpawnEnemies): SpawnFunctions.SpawnWave(1, [Vector2(200,400), Vector2(100,-100), Vector2(200,0), Vector2(100,300)], self)
	return;

func InitSpawnpoints() -> void:
	PlayerSpawnpoint = Spawnpoints.get_child(0).get_child(0).position;
	
	for _marker in Spawnpoints.get_children():
		EnemySpawnpoints.append(_marker.position);
		continue;
	return;
