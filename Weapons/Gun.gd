extends BaseWeapon
@export var UseAnimations : AnimationPlayer

func UseWeapon(_useTime : float = Stats.LingerTime) -> void:
	if (!CanUse): return;
	#super(_useTime)
	#UseAnimations.play("UseWeaponAnim")
	HitboxPreview.visible = true;
	UseAnimations.play("UseGun");
	super.UseWeapon(Stats.LingerTime);
	return;

func OnHit(_hit) -> void:
	super(_hit);
	var BurnBuff : Node2D = load("res://Buffs/Burn.tscn").instantiate();
	var SlowBuff : Node2D = load("res://Buffs/Tired.tscn").instantiate();
	#BurnBuff.Stats.Strength = 0
	_hit.AddBuff(SlowBuff)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	HitboxPreview.visible = false;
	return;
