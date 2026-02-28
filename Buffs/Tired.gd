extends BaseBuff

@export var ColourMod : Color;

var OldPlayerMVSMult;
var OldPlayerMVSFlat;
var OldPlayerMod;

func ProcEffect() -> void:
	return;

func ProcOnCondition() -> void:
	return;

func ProcOnce() -> void:
	if (!Owner): Owner = get_parent().get_parent();
	
	OldPlayerMVSFlat = Owner.MoveSpeedFlat;
	OldPlayerMVSMult = Owner.MoveSpeedMult;
	OldPlayerMod = Owner.modulate;
	
	Owner.MoveSpeedFlat *= 0.5;
	Owner.MoveSpeedMult *= 0.5;
	Owner.modulate = ColourMod;
	
	Owner.Recalculate();
	return;

func ExpireBuff() -> void:
	Owner.MoveSpeedFlat += 0.5 * OldPlayerMVSFlat;
	Owner.MoveSpeedMult += 0.5 * OldPlayerMVSMult;
	Owner.modulate = OldPlayerMod;
	
	Owner.Recalculate();
	#print("BuffRemoved")
	return;
