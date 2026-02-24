extends Node2D

var SpawnFunctions = BaseSpawn.new();
@export var MapRule : MapRules;

var PlayerSpawnpoint : Vector2 = Vector2.ZERO;
var EnemySpawnpoints : Array[Vector2] = [];
@onready var Spawnpoints : Node2D = $Spawnpoints;
func _ready() -> void:
	ConnectSignals();
	InitSpawnpoints();
	SpawnFunctions.Spawn("BasePlayer", PlayerSpawnpoint, self)
	
	if (MapRule.SpawnEnemies): SpawnFunctions.SpawnWave(1, EnemySpawnpoints, self)
	
	return;

func ConnectSignals() -> void:
	EventBus.UnitKilled.connect(print);
	return;

func InitSpawnpoints() -> void:
	PlayerSpawnpoint = Spawnpoints.get_child(0).get_child(0).position;
	
	for _marker in Spawnpoints.get_child(1).get_children():
		EnemySpawnpoints.append(_marker.position);
		continue;
	return;
