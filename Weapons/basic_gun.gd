extends BaseWeapon

@export var Projecile : BaseProjectile;

@export var AmmoBar : ProgressBar;

@export var ProjectileNode : Node2D;

func UseWeapon(_duration: float = Stats.LingerTime) -> void:
	if (AmmoBar.value <= 0): Reload(); return;
	
	var NewProj : BaseProjectile = Projecile.duplicate();
	
	NewProj.Damage = 10;
	NewProj.LiveDuration = 60;
	NewProj.WeaponItCameFrom = self;
	ProjectileNode.add_child(NewProj);
	
	AmmoBar.value -= 1;
	return;

func KillAllProjectiles() -> void:
	for i in ProjectileNode.get_children():
		i.queue_free();
		continue;
	
	return;

func Reload() -> void:
	AmmoBar.value = AmmoBar.max_value;
	return;
