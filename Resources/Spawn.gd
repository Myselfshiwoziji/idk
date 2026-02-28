extends Node
class_name BaseSpawn

var UnitArray;
#Wave number: spawned units
var WaveInformation : Dictionary[int, Dictionary] = {
	#waves start at 1
	#spawned unit (string): number (int)
	#Random takes a random enemy from the RandomList array
	#Defaults to -1 if there exists no wave corresponding to wave number
	1: {
		"BaseEnemy": 5
	},
	
	2: {
		"BaseEnemy": 10,
	},
	
	-1: {
		"Random": 5,
		"RandomList": [],
	},
}

#@onready var UnitBase = preload("res://unit_base.tscn");
func Spawn(_unitName : String, _location : Vector2, _parent : Variant) -> void:
	var NewUnit = preload("res://unit_base.tscn").instantiate();
	if (!load("res://Resources/UnitStats/" + _unitName + ".tres")): return;
	NewUnit.Stats = load("res://Resources/UnitStats/" + _unitName + ".tres");
	NewUnit.position = _location;
	_parent.add_child(NewUnit);
	UnitArray["Friendly" if NewUnit.Stats.IsFriendly else "NotFriendly"] += 1
	
	NewUnit.WeaponRingPlacementNode.AddWeaponSpritesToMarker(NewUnit.WeaponsNode.get_children(), 110);
	
	for _weapon in NewUnit.WeaponsNode.get_children():
		NewUnit.WeaponMenu.AddWeaponButton(_weapon);
		continue;
	#NewUnit.AddBuff(load("res://Buffs/Burn.tscn"));
	return;

#TODO add weighed distributions
func RandomSpawn(_unitName : String, _spawnLocations : Array[Vector2], _parent : Variant, weighed : bool = false) -> void:
	Spawn(_unitName, _spawnLocations[randi_range(0, len(_spawnLocations) - 1)], _parent);
	return;
#func _ready() -> void:
	#Spawn("BasePlayer", Vector2(0,0));

func _getRandomEnemy(_list : Array[String]) -> String:
	var Randint = randi_range(0, len(_list) - 1);
	var EnemyName : String = _list[Randint];
	return EnemyName;

#Wave number begins at 1 but is indexed correctly (array - 1)
func SpawnWave(_waveNumber : int, _spawnLocations : Array[Vector2], _parent : Variant) -> void:
	var Wave : Dictionary = WaveInformation[_waveNumber] if WaveInformation[_waveNumber] else WaveInformation[-1];
	#Define special behaviour for random
	
	#Iterate through each unit
	for _unit : String in Wave:
		#Spawn each unit amount of times corresponding to values
		for _times in range(0, Wave[_unit] - 1):
			RandomSpawn(_unit, _spawnLocations, _parent);
			continue;
		continue;
	return;
