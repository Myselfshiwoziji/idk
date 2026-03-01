extends Node2D
class_name BaseWeapon

@export var Stats : WeaponStats;

#@export var Sprite : Texture2D;
@export var Hitbox : Area2D;
#@export var BaseDamage : int;
#@export var Scaling : float = 0;
#@export var BaseCooldown : float = 5;
@export var Animations : AnimatedSprite2D;
#@export var UseDisplacement : bool = true;
#@export var LingerTime : float = 0.3;
#@export var CanHitFriendly : bool = false;

@export var HitboxPreview : Control;

var HitboxOffset : Vector2;
var WeaponParent : CharacterBody2D;
var Damage : float;
var CanHit : bool = false;
var Cooldown : float;
var CanUse : bool;

var TempMultipliers : Array[String] = [];

@export var MarkerSprite : Sprite2D;

func _ready():
	HitboxOffset = Hitbox.position;
	Damage = Stats.BaseDamage;
	CanUse = true;
	Cooldown = Stats.BaseCooldown;
	return;

func ConfigureOffset(_direction: Vector2) -> void:
	if (!Stats.UseDisplacement): return;
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
		if (!WeaponParent.Stats.Controlling): 
			if (len(WeaponParent.UnitsInRadius) == 0): return;
			ConfigureOffset(WeaponParent.UnitsInRadius[0].position - WeaponParent.position);
			return;
		else:
			ConfigureOffset(get_global_mouse_position() - WeaponParent.position)
			return;
	return;

func DamageScaling() -> float:
	return Damage + WeaponParent.Attack * Stats.Scaling;

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (!area.get_parent().is_class("CharacterBody2D") || !CanHit): return;
	var UnitHit : CharacterBody2D = area.get_parent();
	if (UnitHit.Stats.IsFriendly == WeaponParent.Stats.IsFriendly && !Stats.CanHitFriendly): return;
	OnHit(UnitHit)
	return;

func OnHit(_hit : CharacterBody2D) -> void:
	#if (_hit.Stats.IsFriendly == WeaponParent.Stats.IsFriendly && !_canHitFriendly): return;
	_hit.TakeDamage(DamageScaling());
	return;

func ActivateHitbox(_duration : float) -> void:
	Hitbox.monitoring = true;
	CanHit = true;
	CanUse = false;
	
	await get_tree().create_timer(_duration).timeout;
	Hitbox.monitoring = false;
	CanHit = false;
	await get_tree().create_timer(Cooldown - _duration if Cooldown > _duration else 0.0).timeout;
	CanUse = true;
	return;

func UseWeapon(_duration: float = Stats.LingerTime) -> void:
	if (!CanUse): return;
	ActivateHitbox(_duration);
	if (Animations):
		Animations.visible = true;
		Animations.play("Slash");
	HitboxPreview.visible = true;
	return;

func _on_animated_sprite_2d_animation_finished() -> void:
	if (Animations):
		Animations.visible = false;
	HitboxPreview.visible = false;
