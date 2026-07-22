extends Control

@export var CursorInformation : Panel;

var TrackingMovement : bool:
	get:
		return TrackingMovement;
	set(_value):
		TrackingMovement = _value;
		set_process(_value);

func _process(delta: float) -> void:
	if (!CursorInformation): return;
	
	CursorInformation.position = get_local_mouse_position();
	return;
