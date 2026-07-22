extends ProgressBar

var MaxCooldown : float:
	get:
		return MaxCooldown;
	set(_newValue):
		MaxCooldown = _newValue;
		self.max_value = MaxCooldown;

var CurrentCooldown : float:
	get:
		return CurrentCooldown;
	set(_newValue):
		CurrentCooldown = _newValue;
		self.value = CurrentCooldown;
		
		if (self.value <= 0): queue_free();

var CooldownMult : float = 1;
