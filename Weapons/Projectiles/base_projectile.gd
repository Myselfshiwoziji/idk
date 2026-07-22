extends Node2D
class_name BaseProjectile

@export var Hitbox : Area2D;


#var Owner : CharacterBody2D;
var WeaponItCameFrom : BaseWeapon;

var Damage : float = 0;

var Speed : float = 1;

var TimeElapsed : float = 0;
var LiveDuration : float = 0;

var Pierce : int = 0;

func _ready() -> void:
	
	set_process(false);
	return;

func InitProjectile() -> void:
	Hitbox.area_entered.connect(AreaEnter);
	set_process(true);
	return;

func ValidityCheck(_area : Area2D) -> bool:
	if (!_area.get_parent().is_class("CharacterBody2D")): return false;
	if (_area.get_parent() == WeaponItCameFrom.WeaponParent): return false;
	return true;

func _process(delta: float) -> void:
	TimeElapsed += delta;
	if (TimeElapsed >= LiveDuration): queue_free();
	MovementPath();
	return;

func MovementPath(_time : float = TimeElapsed) -> void:
	position.y -= Speed * cos(rotation);
	position.x += Speed * sin(rotation);
	return;

func AreaEnter(_area : Area2D) -> void:
	if (!ValidityCheck(_area)): return;
	#Set what it can and cant hit in ValidityCheck
	
	HitSomething(_area);
	
	if (Pierce <= 0): queue_free();
	return;

func HitSomething(_area : Area2D) -> void:
	if (_area.get_parent().is_class("CharacterBody2D")):
		_area.get_parent().TakeDamage(Damage);
		return;
	return;
