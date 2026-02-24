extends Node2D
class_name BaseWeapon

@export var Sprite : Texture2D;
@export var Hitbox : Area2D;
@export var BaseDamage : int;
@export var BaseCooldown : float = 5;
@export var Animations : AnimatedSprite2D;
@export var UseDisplacement : bool = true;
@export var LingerTime : float = 0.3;

var HitboxOffset : Vector2;
var WeaponParent : CharacterBody2D;
var Damage : float;
var CanHit : bool = false;
var Cooldown : float;
var CanUse : bool;

var TempMultipliers : Array[String] = [];

func _ready():
	HitboxOffset = Hitbox.position;
	Damage = BaseDamage;
	CanUse = true;
	Cooldown = BaseCooldown;
	return;

func ConfigureOffset(_direction: Vector2) -> void:
	if (!UseDisplacement): return;
	#incase its not normalised already
	_direction = _direction.normalized();
	var Magnitude = HitboxOffset.length();
	
	Hitbox.position.x = Magnitude * cos( _direction.angle());
	Hitbox.position.y = Magnitude * sin( _direction.angle());
	
	#Hitbox.rotation = rad_to_deg(_direction.angle());
	Hitbox.look_at(WeaponParent.position + _direction * 1000)
	Hitbox.rotate(PI/2)
	return;

func _process(delta: float) -> void:
	if (WeaponParent): 
		if (!WeaponParent.Stats.Controlling): return;
		ConfigureOffset(get_global_mouse_position() - WeaponParent.position)
	return;

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (!area.get_parent().is_class("CharacterBody2D") || area.get_parent() == WeaponParent || !CanHit): return;
	var UnitHit : CharacterBody2D = area.get_parent();
	UnitHit.TakeDamage(Damage);
	return;

func ActivateHitbox(_duration : float) -> void:
	Hitbox.monitoring = true;
	CanHit = true;
	CanUse = false;
	
	await get_tree().create_timer(_duration).timeout;
	Hitbox.monitoring = false;
	CanHit = false;
	await get_tree().create_timer(Cooldown - _duration if Cooldown > _duration else 0).timeout;
	CanUse = true;
	return;

func UseWeapon(_duration: float) -> void:
	if (!WeaponParent.Stats.Controlling || !CanUse): return;
	ActivateHitbox(_duration);
	Animations.visible = true;
	Animations.play("Slash");
	return;

func _on_animated_sprite_2d_animation_finished() -> void:
	Animations.visible = false;
