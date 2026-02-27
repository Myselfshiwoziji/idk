extends Button

#Temp
@export var ControlledUnit : CharacterBody2D;
@export var Weapon : PackedScene;

@export var WeaponDescriptionPanel : Panel

var WeaponNode

func _ready() -> void:
	WeaponNode = Weapon.instantiate();
	InitPanel()
	return;

func InitPanel() -> void:
	if (!WeaponNode): return;
	var WeaponStat : WeaponStats = WeaponNode.Stats;
	WeaponDescriptionPanel.get_child(WeaponDescriptionPanel.get_children().find("Name")).text = "Hello";
