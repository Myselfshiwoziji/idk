extends BaseWeapon
@export var UseAnimations : AnimationPlayer

func UseWeapon(_useTime : float = LingerTime) -> void:
	if (!CanUse): return;
	#super(_useTime)
	#UseAnimations.play("UseWeaponAnim")
	HitboxPreview.visible = true;
	UseAnimations.play("UseWeaponAnim");
	return;


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	super.UseWeapon(LingerTime);
	#HitboxPreview.visible = false
	return;

func OnHit(_hit) -> void:
	super(_hit);
	var BurnBuff : Node2D = load("res://Buffs/Burn.tscn").instantiate();
	#BurnBuff.Stats.Strength = 0
	_hit.AddBuff(BurnBuff);
	return;
