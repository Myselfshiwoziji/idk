extends BaseWeapon
@export var UseAnimations : AnimationPlayer

func UseWeapon(_useTime : float = LingerTime) -> void:
	if (!CanUse): return;
	#super(_useTime)
	#UseAnimations.play("UseWeaponAnim")
	HitboxPreview.visible = true;
	UseAnimations.play("UseWeaponAnim");
	return;


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	super.UseWeapon(LingerTime);
	HitboxPreview.visible = false
	return;
