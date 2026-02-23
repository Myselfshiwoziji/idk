extends CharacterBody2D

@onready var DetectionRadius : Area2D = $DetectionRadius;
@onready var Hitbox : CollisionShape2D = $Hitbox;
@onready var Healthbar : ProgressBar = $Health;

@export var Stats : BaseUnit;

#@onready var DetectionRadius = $DetectionRadius;
@onready var Camera = $Camera2D

var Attack;
var Defense;
var MoveSpeed;
var MaxHealth;
var Health;

var Chasing : bool = false;
var UnitsInRadius : Array[CharacterBody2D];

func _ready() -> void:
	Init();
	if (Stats.Controlling):
		DetectionRadius.monitoring = false;
		Camera.enabled = true;
	return;

func Init():
	Attack = Stats.BaseAttack;
	Defense = Stats.BaseDefense;
	MaxHealth = Stats.BaseMaxHealth;
	Health = MaxHealth;
	MoveSpeed = Stats.BaseMoveSpeed;
	Healthbar.max_value = MaxHealth;
	Healthbar.value = MaxHealth;
	
	$Sprite2D.texture = Stats.Sprite;
	for _weaponName : String in Stats.HeldWeapons:
		var Weapon : Node2D = load("res://Weapons/" + _weaponName + ".tscn").instantiate();
		$Weapons.add_child(Weapon);
		Weapon.WeaponParent = self
		Weapon.HitboxOffset = Vector2(0,-Stats.WeaponDisplacement);
	return;

func _physics_process(delta: float) -> void:
	move_and_slide()
	if (Stats.Controlling): 
		Controllable();
		#DynamicCamera();
	else:
		if (Chasing): ChaseLogic(UnitsInRadius[0], Stats.BufferRadius)
		return;
	return;

func Controllable() -> void:
	var InputVector = Vector2.ZERO;
	InputVector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left");
	InputVector.y = - Input.get_action_strength("Up") + Input.get_action_strength("Down");
	velocity = InputVector.normalized() * MoveSpeed;
	
	return;

func ChaseLogic(_unit : CharacterBody2D, _bufferDistance : float = 0, _zone : int = 10) -> void:
	var Magnitude : float = (_unit.position - self.position).length();
	#var Direction : Vector2 = (_unit.position - self.position).normalized() if Magnitude >= _bufferDistance else (self.position - _unit.position).normalized();
	
	var Direction : Vector2;
	if (Magnitude > _bufferDistance + _zone):
		Direction = (_unit.position - self.position).normalized();
	elif (Magnitude < _bufferDistance - _zone):
		Direction = (self.position - _unit.position).normalized();
	else:
		#Attack here
		pass;
	#print(self.name + " is chasing " + _unit.name)
	velocity = Direction * MoveSpeed;
	return;

func TakeDamage(_rawAmount : int) -> void:
	#Minimum damage taken is 1
	Health -= (_rawAmount - Defense) if _rawAmount > Defense else 1;
	Healthbar.value = Health;
	
	if (Health <= 0): self.queue_free();
	return;

func DynamicCamera() -> void:
	var Direction : Vector2 = velocity.normalized();
	Camera.position = Direction * 100;
	return;

func _on_detection_radius_area_entered(area: Area2D) -> void:
	if (Stats.Controlling): return;
	if (!area.get_parent().is_class("CharacterBody2D")): return;
	if (area.get_parent().Stats.IsFriendly == Stats.IsFriendly): return;
	
	UnitsInRadius.append(area.get_parent());
	Chasing = true;
	return;

func _on_detection_radius_area_exited(area: Area2D) -> void:
	if (Stats.Controlling): return;
	if (!area.get_parent().is_class("CharacterBody2D")): return;
	if (area.get_parent().Stats.IsFriendly == Stats.IsFriendly): return;
	
	UnitsInRadius.remove_at(UnitsInRadius.find(area.get_parent()));
	if (len(UnitsInRadius) == 0): Chasing = false;
	return;

func _input(event: InputEvent) -> void:
	if (!Stats.Controlling): return;
	if (Input.is_action_just_pressed("m1")):
		$Weapons/Weapon.UseWeapon(0.3)
		return;
	return;
