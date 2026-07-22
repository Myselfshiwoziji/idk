extends Control

@export var Rando : WeightedRandom;

@export var VBox : VBoxContainer;
@export var TheButton : Button;
@export var TheLabel : Label;
@export var RollHistoryLabel : Label

@export var AmountLabel : TextEdit;

func _ready() -> void:
	UpdateGoldAmount(DataInRun.Gold)
	EventBus.GoldChanged.connect(UpdateGoldAmount)
	EventBus.LevelChanged.connect(UpdateLevel);
	
	#AddContentToVBox("Common", (CalculateOdds("Epic", OddsTable)), {"Gold": 20.5, "Blabla": 30})
	RarityToVBox(OddsTable, LootTable, false)
	

var OddsTable : Dictionary[String, float] = {
	"Common": 100.0,
	
	"Rare": 50.0,
	
	"Epic": 1.0,
	
	"Legendary": 0.1
	
}

var LootTable : Dictionary[String, Dictionary] = {
	"Common": {
		"Gold": 50,
		"Exp": 100,
	},
	
	"Rare": {
		"Gold": 1000,
		"Exp": 5000,
	},
	
	"Epic": {
		"Gold": 5000,
		"Exp": 90000,
	},
	
	"Legendary": {
		"Tickets to an island": 1,
	}
}

func CalculateOdds(_rarity : String, _rarityTable : Dictionary[String, float]) -> float:
	var RarityNum : float = _rarityTable[_rarity];
	var TotalRarity : float;
	
	for i in _rarityTable.values():
		TotalRarity += i;
		continue;
	
	return RarityNum/TotalRarity;

func AddContentToVBox(_rarityName : String, _rarity : float, _contents : Dictionary) -> void:
	var NewButton : Button = TheButton.duplicate();
	var NewLabel = TheLabel.duplicate();
	
	NewButton.text = _rarityName + " (" + str(round(_rarity * 10000)/100) + "%)";
	VBox.add_child(NewButton);
	VBox.add_child(NewLabel);
	
	NewButton.visible = true;
	NewButton.pressed.connect(MakeLabelAppearDisappear.bind(NewLabel));
	
	var LabelText : String = "";
	for i in _contents:
		LabelText += i + ": " + str(_contents[i]) + '\n';
		continue;
	
	NewLabel.text = LabelText;
	return;

func RarityToVBox(_table : Dictionary[String, float], _table2 : Dictionary[String, Dictionary], _clear : bool = false) -> void:
	if (_clear): DeleteVBoxContents();
	
	for i in _table:
		AddContentToVBox(i, CalculateOdds(i, _table), _table2[i]);
		continue;
	return;

func DeleteVBoxContents() -> void:
	for i in VBox.get_children():
		i.queue_free();
		continue;
	return;

func MakeLabelAppearDisappear(_label : Label) -> void:
	_label.visible = !_label.visible;
	
	return;

func _on_button_pressed() -> void:
	#print(AmountLabel.text)
	var Amount = int(AmountLabel.text) if (int(AmountLabel.text)) else 1;
	
	for i in Amount:
		if (DataInRun.Gold < 50): return;
		
		DataInRun.Gold -= 50;
		var Result = Rando.GetRarity(OddsTable);
		AddToRollHistory(Result);
		Result = Rando.GetDrop(Result, LootTable);
		
		#if Result.keys()[0] == "Gold":
			#DataInRun.Gold += Result.values()[0];
		
		match Result.keys()[0]:
			"Gold":
				DataInRun.Gold += Result.values()[0];
			"Exp":
				DataInRun.Exp += Result.values()[0];
	return;

func UpdateGoldAmount(_new) -> void:
	$Label.text = "Gold: " + str(_new);
	return;

func UpdateLevel(_old, _new) -> void:
	$Label3.text = "Level: " + str(_new);
	return;

func AddToRollHistory(_rarity : String) -> void:
	RollHistoryLabel.text = _rarity + '\n' + RollHistoryLabel.text;
	return;
