extends CharacterBody2D
signal HealthChanged(_value : float, _reason)
signal MaxHealthChanged(_value : float, _reason)
signal WeaponAdded(_newWeapon);

@onready var DetectionRadius : Area2D = $DetectionRadius;
@onready var Hitbox : CollisionShape2D = $Hitbox;
@onready var Healthbar : ProgressBar = $Health;

@export var Stats : BaseUnit;
@export var WeaponRingPlacementNode : Node2D

@export var WeaponsNode : Node2D;

#@onready var DetectionRadius = $DetectionRadius;
@onready var Camera = $Camera2D

var Attack;
var AttackFlat : float = 0;
var AttackMult : float = 1;

var Defense;
var DefenseFlat : float = 0;
var DefenseMult : float = 1;

var MoveSpeed;
var MoveSpeedFlat : float = 0;
var MoveSpeedMult : float = 1;

var MaxHealth;
var MaxHealthFlat : float = 0;
var MaxHealthMult : float = 1;

var Health;

var DamageRes;
var UsedDamageRes;

var Chasing : bool = false;
var UnitsInRadius : Array[CharacterBody2D];

var Buffs : Dictionary[String, Array] = {}

func _ready() -> void:
	Init();
	if (Stats.Controlling):
		DetectionRadius.monitoring = false;
		Camera.enabled = true;
		$Camera2D/GameUI.visible = true;
	return;

func AddBuff(_buff : PackedScene) -> void:
	var NewBuff := _buff.instantiate();
	$Buffs.add_child(NewBuff);
	NewBuff.Owner = self;
	if (Buffs.keys().find(NewBuff.Stats.BuffName) == -1):
		Buffs[NewBuff.Stats.BuffName] = [NewBuff];
	else:
		Buffs[NewBuff.Stats.BuffName].append(NewBuff);
	return;

func AttackFormula(_base, _mult, _flat) -> float:
	var Final = _base  * _mult + _flat;
	return Final;

func DefenseFormula(_base, _mult, _flat) -> float:
	var Final = _base  * _mult + _flat;
	return Final;

func MaxHealthFormula(_base, _mult, _flat) -> float:
	var Final = _base  * _mult + _flat;
	return Final;

func MoveSpeedFormula(_base, _mult, _flat) -> float:
	var Final = _base  * _mult + _flat;
	return Final;

func DamageResFormula(_res) -> float:
	var Final = 1 - 1.3**(-_res);
	return Final;

func Init():
	Attack = AttackFormula(Stats.BaseAttack, AttackMult, AttackFlat);
	Defense = DefenseFormula(Stats.BaseDefense ,DefenseMult ,DefenseFlat);
	MaxHealth = MaxHealthFormula(Stats.BaseMaxHealth , MaxHealthMult ,MaxHealthFlat);
	Health = MaxHealth;
	MoveSpeed = MoveSpeedFormula(Stats.BaseMoveSpeed ,MoveSpeedMult,MoveSpeedFlat);
	Healthbar.max_value = MaxHealth;
	Healthbar.value = MaxHealth;
	
	#1 = 23.0%, 2 = 40.8%, 3 = 54.4%, 4 = 64.0%, etc.
	DamageRes = Stats.BaseDamageRes;
	UsedDamageRes = DamageResFormula(DamageRes);
	#CalculateUsedDamageRes();
	
	$Sprite2D.texture = Stats.Sprite;
	#for _weaponName : String in Stats.HeldWeapons:
		#var Weapon : Node2D = load("res://Weapons/" + _weaponName + ".tscn").instantiate();
		#$Weapons.add_child(Weapon);
		#Weapon.WeaponParent = self
		#Weapon.HitboxOffset = Vector2(0,-Stats.WeaponDisplacement);
	for _weapon : PackedScene in Stats.HeldWeapons:
		var NewWeapon : Node2D = _weapon.instantiate();
		$Weapons.add_child(NewWeapon);
		NewWeapon.WeaponParent = self
		NewWeapon.HitboxOffset = Vector2(0,-Stats.WeaponDisplacement);
		continue;
	
	#Collision layers
	if (Stats.Controlling):
		self.collision_layer = 1;
		self.collision_mask = 2;
	else:
		self.collision_layer = 2;
		self.collision_mask = 1;
	
	HealthChanged.connect(HealthValueChanged);
	MaxHealthChanged.connect(MaxHealthValueChanged);
	return;

func HealthValueChanged(_new, _reason) -> void:
	Healthbar.value = Health;
	return;

func MaxHealthValueChanged(_new, _reason) -> void:
	Healthbar.max_value = MaxHealth;

#func CalculateUsedDamageRes() -> void:
	#UsedDamageRes = 1 - 1.3**(-DamageRes);
	#return;

func AttackLogic() -> void:
	if (len($Weapons.get_children()) == 0): return;
	for _weapon in $Weapons.get_children():
		_weapon.UseWeapon(_weapon.LingerTime);
		continue;
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
		AttackLogic();
		pass;
	#print(self.name + " is chasing " + _unit.name)
	velocity = Direction * MoveSpeed;
	return;

func TakeDamage(_rawAmount : int) -> void:
	#Minimum damage taken is 1
	_rawAmount = _rawAmount * (1-UsedDamageRes);
	var DamageDealt : float = (_rawAmount - Defense) if _rawAmount > Defense else 1;
	#Health -= (_rawAmount - Defense) if _rawAmount > Defense else 1;
	ChangeHealthValue(Health - DamageDealt);
	
	if (Health <= 0): 
		EventBus.UnitKilled.emit(self)
		self.queue_free();
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
		for _weapon in $Weapons.get_children():
			_weapon.UseWeapon(_weapon.LingerTime);
			continue;
		#$Weapons/Weapon.UseWeapon(0.3)
		return;
	return;

func ChangeHealthValue(_newValue : float, _reason : Variant = null) -> void:
	if (_newValue == Health): return;
	Health = _newValue;
	HealthChanged.emit(_newValue, _reason);
	return;

func ChangeMaxHealthValue(_newValue : float, _reason : Variant = null) -> void:
	if (_newValue == MaxHealth): return;
	MaxHealth = _newValue;
	MaxHealthChanged.emit(_newValue, _reason);
	return;

func AddNewWeapon(_weapon : PackedScene) -> void:
	var NewWeapon := _weapon.instantiate();
	WeaponsNode.add_child(NewWeapon);
	WeaponRingPlacementNode.AddWeaponSpritesToMarker(WeaponsNode.get_children(), 110)
	WeaponAdded.emit(NewWeapon);
	return;
