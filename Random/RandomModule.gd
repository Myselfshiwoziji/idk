extends Resource
class_name WeightedRandom

@export var RarityTable : Dictionary = {
	"Common": 10,
	"Rare": 4,
	"Legendary": 1,
}

@export var LootTable : Dictionary = {
	"Common": {
		"gold": 1,
	},
	"Rare": {
		"gold": 100,
	},
	"Legendary": {
		"gold": 1000,
	},
}

func GetRarity(_customTable = {}, _rerollAmount = 1) -> String:
	var WeighedSum : float;
	
	RarityTable = _customTable if (_customTable != {}) else RarityTable;
	
	for _value in RarityTable.values():
		WeighedSum += _value;
		continue;
	
	var RandNum = randf_range(0, WeighedSum);
	
	RandNum = RandNum if (_rerollAmount <= 1) else (RandNum/WeighedSum)**(1/_rerollAmount) * WeighedSum;
	
	for _rarity in RarityTable:
		if (RandNum <= RarityTable[_rarity]):
			return _rarity;
		
		RandNum -= RarityTable[_rarity];
	return "Common";

func GetDrop(_rarity : String, _customTable = {}) -> Dictionary:
	LootTable = _customTable if (_customTable != {}) else LootTable;
	
	var TotalNumber : int = len(LootTable[_rarity].values());
	var ChosenNumber : int = randi_range(0, TotalNumber-1);
	
	return {LootTable[_rarity].keys()[ChosenNumber]: LootTable[_rarity].values()[ChosenNumber]};

func GetRarityAndDrop(_customRarity = {}, _customLoot = {}) -> Dictionary:
	return GetDrop(GetRarity(_customRarity), _customLoot);

func CompareRarity(_rarity1 : String, _rarity2 : String, _returnRarer = true, _customTable = {}) -> String:
	
	#Higher rarity = more common
	RarityTable = _customTable if (_customTable != {}) else RarityTable;
	var Is1HigherThan2 : bool = RarityTable[_rarity1] > RarityTable[_rarity2];
	
	return _rarity1 if (!Is1HigherThan2 || (Is1HigherThan2 && !_returnRarer)) else _rarity2;

func GenerateRarityArray(_number : int, _customTable = {}) -> Array[String]:
	var TotalArray : Array[String] = [];
	for i in _number:
		TotalArray.append(GetRarity(_customTable));
		continue;
	return TotalArray;

func GetHighestRarity(_array : Array[String], _customTable) -> String:
	var CurrentHighest : String = _array[0];
	for i in _array:
		CurrentHighest = CompareRarity(CurrentHighest, i, true, _customTable);
		continue;
	return CurrentHighest;
