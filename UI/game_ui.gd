extends Control

@export var CooldownBar : ProgressBar;
@export var WeaponLabel : Label;

@export var VBox : VBoxContainer;

@export var Default : ProgressBar;

var IsOnCooldown: bool = false;

var CooldownsActive : bool = false:
	get:
		return CooldownsActive;
	set(_newValue):
		CooldownsActive = _newValue;
		set_process(_newValue);

var MaxCooldown : int:
	get:
		return MaxCooldown;
	set(_newValue):
		MaxCooldown = _newValue;
		CooldownBar.max_value = MaxCooldown;

var CurrentCooldown : float:
	get:
		return CurrentCooldown;
	set(_newValue):
		CurrentCooldown = _newValue;
		CooldownBar.value = CurrentCooldown;
		if (CurrentCooldown > 0): 
			IsOnCooldown = true;
			set_process(true);
		else:
			set_process(false);
			IsOnCooldown = false;

#func _ready() -> void:
	#AddNewBar("Bomb", 10);
	#return;

func _process(delta: float) -> void:
	if (CurrentCooldown <= 0 && VBox.get_child_count() == 0): IsOnCooldown = false; set_process(false); return;
	
	#CurrentCooldown -= delta;
	#CooldownBar.value = CurrentCooldown;
	
	for i : ProgressBar in VBox.get_children():
		i.CurrentCooldown -= delta * i.CooldownMult;
		continue;
	return;

func AddNewBar(_name : String, _cooldownMax : float, _mult : float = 1) -> void:
	var NewBar : ProgressBar = Default.duplicate();
	#NewBar.MaxCooldown = 15;
	#NewBar.CurrentCooldown = 10;
	NewBar.get_child(0).text = _name
	NewBar.MaxCooldown = _cooldownMax;
	NewBar.CurrentCooldown = _cooldownMax;
	NewBar.CooldownMult = _mult;
	NewBar.visible = true;
	VBox.add_child(NewBar);
	CooldownsActive = true;
	set_process(true);
	return;
