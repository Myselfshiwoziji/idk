extends Node2D

var SpawnFunctions = BaseSpawn.new();
@export var MapRule : MapRules;

var PlayerSpawnpoint : Vector2 = Vector2.ZERO;
var EnemySpawnpoints : Array[Vector2] = [];

var CurrentWave: int = 1

var UnitsOnMap : Dictionary[String, int] = {
	"Friendly": 0,
	"NotFriendly": 0,
};

@onready var Spawnpoints : Node2D = $Spawnpoints;
func _ready() -> void:
	SpawnFunctions.UnitArray = UnitsOnMap
	ConnectSignals();
	InitSpawnpoints();
	SpawnFunctions.Spawn("BasePlayer", PlayerSpawnpoint, self)
	
	if (MapRule.SpawnEnemies): SpawnFunctions.SpawnWave(CurrentWave, EnemySpawnpoints, self)
	
	return;

func ConnectSignals() -> void:
	EventBus.UnitKilled.connect(UnitIsKilled);
	return;

func UnitIsKilled(_unit):
	var AreTheyFriendly = "Friendly" if _unit.Stats.IsFriendly else "NotFriendly";
	UnitsOnMap[AreTheyFriendly] -= 1;
	print(UnitsOnMap["NotFriendly"])
	WaveSpawning()
	return;

func WaveSpawning() -> void:
	if (!MapRule.SpawnEnemies): return;
	if (UnitsOnMap["NotFriendly"] == 0): 
		CurrentWave += 1;
		SpawnFunctions.SpawnWave(CurrentWave, EnemySpawnpoints, self)
	return;

func InitSpawnpoints() -> void:
	PlayerSpawnpoint = Spawnpoints.get_child(0).get_child(0).position;
	
	for _marker in Spawnpoints.get_child(1).get_children():
		EnemySpawnpoints.append(_marker.position);
		continue;
	return;
