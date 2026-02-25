extends Node2D
class_name BaseBuff

@export var Stats : BuffStats;

var Duration : float;
var TimePassed : float;
var Owner : CharacterBody2D;

func _ready() -> void:
	Init();
	ProcOnTime();
	ProcOnce();
	ProcOnCondition();
	return;

func Init() -> void:
	Duration = Stats.DefaultDuration;
	return;

func ProcEffect() -> void:
	push_warning("Buff proc for " + Stats.BuffName + ", did you forget to override?")
	return;

#Proc (condition) effects are meant to be overriden (all 3 will proc at applied buff otherwise)
func ProcOnTime(_interval : float = 1) -> void:
	var Timed : Timer = Timer.new();
	Timed.wait_time = _interval;
	self.add_child(Timed);
	Timed.start()
	Timed.timeout.connect(ProcEffect);
	return;

func ProcOnce() -> void:
	ProcEffect();
	return;

func ProcOnCondition() -> void:
	return;

func ExpireBuff() -> void:
	return;

func RemoveFromOwnerBuffIndex() -> void:
	if (!Owner): return;
	var BuffArray : Array[BaseBuff] = Owner.Buffs[self.name];
	var SpecificBuffIndex : int = BuffArray.find(self);
	
	if (SpecificBuffIndex == -1): push_warning("Cant find buff!"); return;
	BuffArray.remove_at(SpecificBuffIndex);
	return;

func CheckIfBuffExpired() -> void:
	if (TimePassed > Duration): 
		ExpireBuff();
		RemoveFromOwnerBuffIndex();
		self.queue_free();
	return;

func _process(delta: float) -> void:
	TimePassed += delta;
	
	CheckIfBuffExpired();
	return;
