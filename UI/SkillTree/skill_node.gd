extends Control
class_name SkillNode;

@export_category("Init stuff")
@export var ControlPanel : Panel;
@export var NameLabel : Label;
@export var DescLabel : Label;
@export var CostLabel : Label;
@export var Progress : ProgressBar;
@export var UpgradeButton : Button;
#@export var LineClone : Line2D;

var MaxUpgrades : int:
	get:
		return MaxUpgrades;
	set(_value):
		MaxUpgrades = _value;
		Progress.max_value = _value;
		ConfigUpgradeCost();
		if (CurrentUpgrade > MaxUpgrades): CurrentUpgrade = MaxUpgrades;

var CurrentUpgrade : int:
	get:
		return CurrentUpgrade;
	set(_value):
		Progress.value = _value;
		CurrentUpgrade = _value;
		CostLabel.text = "Cost: " + str(UpgradeCostArray[CurrentUpgrade]);
		CheckIfUpgradeAvailable();

@export_category("Upgrade information")
@export var UpgradeName : String;
@export var UpgradeDesc : String;
@export var UpgradeCostBase : float;
@export var StatUpgraded : String;
@export var MaxUpgradeBase : int;
@export var AdvancesTo : Dictionary[int, Array];

var Owner;

var CanBeUpgraded : bool:
	get:
		return CanBeUpgraded;
	set(_value):
		CanBeUpgraded = _value;
		if (_value): ControlPanel.modulate = "ffffff";
		else:
			ControlPanel.modulate = "90d0ca" if (Progress.value == Progress.max_value) else "ff3838";
			UpgradeButton.disabled = true;

var UpgradeCostArray : Array[float] = [UpgradeCostBase];

func _ready() -> void:
	#AddNewLine()
	InitUpgrade();
	return;

func InitUpgrade() -> void:
	MaxUpgrades = MaxUpgradeBase;
	NameLabel.text = UpgradeName;
	DescLabel.text = UpgradeDesc;
	Progress.value = CurrentUpgrade;
	#ConfigUpgradeCost();
	CostLabel.text = "Cost: " + str(UpgradeCostArray[CurrentUpgrade]);
	return;

func ConfigUpgradeCost() -> void:
	UpgradeCostArray = [];
	for i in range(0, MaxUpgrades+1):
		UpgradeCostArray.append(UpgradeCostBase * 1.5**i);
		continue;
	
	return;

func CheckIfUpgradeAvailable() -> void:
	for i in AdvancesTo.keys():
		if (CurrentUpgrade < i): continue;
		var UpgradeArray : Array = AdvancesTo[i];
		for j in UpgradeArray:
			var UpgradeNode = get_node(j);
			if (UpgradeNode.visible): return;
			UpgradeNode.visible = true;
			AddNewLine(UpgradeNode.position);
		continue;
	return;

func AddNewLine(_location : Vector2 = Vector2(128,128)) -> void:
	var NewLine : Line2D = Line2D.new();
	self.add_child(NewLine);
	NewLine.points = [Vector2.ZERO, Vector2.ZERO];
	NewLine.position = Vector2(128,128);
	NewLine.points[1] = _location - self.position;
	NewLine.default_color = "ffffff88";
	NewLine.z_index = -1;
	NewLine.visible = true;
	return;

func _on_button_pressed() -> void:
	PurchaseUpgrade()
	return;

func PurchaseUpgrade() -> void:
	CurrentUpgrade += 1;
	
	if (Progress.value == Progress.max_value):
		CanBeUpgraded = false;
		return;
	return;
