extends BaseBuff

func _ready() -> void:
	super();
	$Sprite2D.texture = Stats.Sprite;
	return;

func ProcEffect() -> void:
	#if (!Owner): Owner = get_parent().get_parent();
	#Owner.ChangeHealthValue(Owner.Health * 0.5, "Burn");
	Owner.ChangeMaxHealthValue(Owner.MaxHealth * 1.5);
	$Sprite2D.visible = true;
	await get_tree().create_timer(0.1).timeout;
	$Sprite2D.visible = false;
	return;

func ProcOnCondition(_new = 0, _reason = null) -> void:
	#if (!_reason || _reason == "idk"): return;
	#Owner.ChangeHealthValue(Owner.Health + 10, "idk");
	return;

func ProcOnce() -> void:
	if (!Owner): Owner = get_parent().get_parent();
	#Owner.MaxHealthChanged.connect(ProcOnCondition);
	return;
