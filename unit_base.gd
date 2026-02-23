extends CharacterBody2D
class_name BaseUnit

@export_category("Unit data")
@export var Controlling : bool;
@export var IsFriendly : bool;
@export var CanAttack : bool;
@export var Sprite : Texture2D;
@export var DetectionRadius = Area2D;
@export var Hitbox = CollisionShape2D;
@export var WeaponDisplacement : int;
@export var Healthbar : ProgressBar;

@export_category("Unit information")
@export var Name : String;
@export var BaseAttack : int;
@export var BaseDefense : int;
@export var BaseMoveSpeed : int;
@export var BaseMaxHealth : int;
@export var BufferRadius : int = 0;

#@onready var DetectionRadius = $DetectionRadius;
@onready var Camera = $Camera2D

var Attack;
var Defense;
var MoveSpeed;
var MaxHealth;
var Health;

var Chasing : bool;
var UnitsInRadius : Array[BaseUnit];

func _ready() -> void:
	Init();
	if (Controlling):
		DetectionRadius.monitoring = false;
		Camera.enabled = true;
	return;

func Init():
	Attack = BaseAttack;
	Defense = BaseDefense;
	MaxHealth = BaseMaxHealth;
	Health = MaxHealth;
	MoveSpeed = BaseMoveSpeed;
	Healthbar.max_value = MaxHealth;
	Healthbar.value = MaxHealth;
	for _weapon in $Weapons.get_children():
		_weapon.WeaponParent = self
		_weapon.HitboxOffset = Vector2(0,-WeaponDisplacement);
	return;

func _physics_process(delta: float) -> void:
	move_and_slide()
	if (Controlling): 
		Controllable();
		DynamicCamera();
	else:
		if (Chasing): ChaseLogic(UnitsInRadius[0], BufferRadius)
		return;
	return;

func Controllable() -> void:
	var InputVector = Vector2.ZERO;
	InputVector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left");
	InputVector.y = - Input.get_action_strength("Up") + Input.get_action_strength("Down");
	velocity = InputVector.normalized() * MoveSpeed;
	
	return;

func ChaseLogic(_unit : BaseUnit, _bufferDistance : float = 0) -> void:
	var Magnitude : float = (_unit.position - self.position).length();
	var Direction : Vector2 = (_unit.position - self.position).normalized() if Magnitude >= _bufferDistance else (self.position - _unit.position).normalized();
	
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
	if (Controlling): return;
	if (!area.get_parent().is_class("CharacterBody2D")): return;
	if (area.get_parent().IsFriendly == IsFriendly): return;
	
	Chasing = true;
	UnitsInRadius.append(area.get_parent());
	return;

func _on_detection_radius_area_exited(area: Area2D) -> void:
	if (Controlling): return;
	if (!area.get_parent().is_class("CharacterBody2D")): return;
	if (area.get_parent().IsFriendly == IsFriendly): return;
	
	UnitsInRadius.remove_at(UnitsInRadius.find(area.get_parent()));
	if (len(UnitsInRadius) == 0): Chasing = false;
	return;

func _input(event: InputEvent) -> void:
	if (!Controlling): return;
	if (Input.is_action_just_pressed("m1")):
		$Weapons/Weapon.UseWeapon(0.3)
		return;
	return;
