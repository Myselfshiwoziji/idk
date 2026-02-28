extends Button
signal ChangeView(_stats);

var ResponsibleWeapon;


func _on_pressed() -> void:
	if (!ResponsibleWeapon): return;
	ChangeView.emit(ResponsibleWeapon);
	return;

func Init() -> void:
	self.text = ResponsibleWeapon.Stats.Name;
