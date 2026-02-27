extends Control

#Temp
@export var ControlledUnit : CharacterBody2D;
@export var Weapon : PackedScene;

@export var WeaponDescriptionPanel : Panel

@onready var WeaponSprite = $MainPanel/WeaponDesc/Panel/Sprite2D
@onready var NameLabel = $MainPanel/WeaponDesc/Panel/Name
@onready var CDmg = $MainPanel/WeaponDesc/Panel/CurrentDamage;
@onready var BCd = $MainPanel/WeaponDesc/Panel/BaseCooldown
@onready var CScaling = $MainPanel/WeaponDesc/Panel/CurrentScaling;
@onready var BDmg = $MainPanel/WeaponDesc/Panel/BaseDamage;
@onready var CCd = $MainPanel/WeaponDesc/Panel/CurrentCooldown;
@onready var BScaling = $MainPanel/WeaponDesc/Panel/BaseScaling;
@onready var WeaponLabel = $MainPanel/WeaponDesc/Panel/WeaponLabel;

var WeaponNode

func _ready() -> void:
	WeaponNode = Weapon.instantiate();
	InitPanel()
	return;

func InitPanel() -> void:
	if (!WeaponNode): return;
	
	var WeaponStat : WeaponStats = WeaponNode.Stats;
	NameLabel.text = WeaponStat.Name;
	WeaponSprite.texture = WeaponStat.Sprite
	BDmg.text = "Damage: " + str(WeaponStat.BaseDamage);
	BCd.text = "Cooldown: " + str(WeaponStat.BaseCooldown);
	BScaling.text = "Scaling: " + str(WeaponStat.Scaling);
	WeaponLabel.text = WeaponStat.Desc
	if (!ControlledUnit): return;
	return;
