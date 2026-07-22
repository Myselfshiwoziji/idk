extends Node

var Gold : float = 100:
	get:
		return Gold;
	set(_value):
		Gold = _value;
		EventBus.GoldChanged.emit(_value);

var Exp : float = 0:
	get:
		return Exp;
	set(_value):
		Exp = _value;
		Level = CheckCurrentLevel();
		EventBus.ExpChanged.emit(_value);

#var ExpToNextLevel : int = ExpLevelFormula(0);

var Level : int = 0:
	get:
		return Level;
	set(_value):
		EventBus.LevelChanged.emit(Level, _value);
		Level = _value;

func ExpLevelFormula(x) -> int:
	return floor((exp(0.5*x))/(x**(1/3) + 1) + 99);

var FirstFiftyLevels = [99, 99, 100, 101, 102, 105, 109, 115, 126, 144, 173, 221, 300, 431, 647, 1003, 1589, 2556, 4150, 6778, 11112, 18256, 30036, 49456, 81476, 134267, 221305, 364807, 601401, 991478, 1634607, 2694948, 4443154, 7325458, 12077575, 19912491, 32830083, 54127592, 89241249, 147133882, 242582696, 399951187, 659407966, 1087179875, 1792456522, 2955261130, 4872401822, 8033232459, 13244561163, 21836589647]

var FirstFiftyLevelsSummed = [0, 99, 198, 298, 399, 501, 606, 715, 830, 956, 1100, 1273, 1494, 1794, 2225, 2872, 3875, 5464, 8020, 12170, 18948, 30060, 48316, 78352, 127808, 209284, 343551, 564856, 929663, 1531064, 2522542, 4157149, 6852097, 11295251, 18620709, 30698284, 50610775, 83440858, 137568450, 226809699, 373943581, 616526277, 1016477464, 1675885430, 2763065305, 4555521827, 7510782957, 12383184779, 20416417238, 33660978401, 55497568048]

func CheckCurrentLevel() -> int:
	for i in 50:
		if (Exp < FirstFiftyLevelsSummed[i]):
			return i-1;
		continue;
	return 50;

#func a() -> void:
	#for i in 50:
		#FirstFiftyLevelsSummed.append(FirstFiftyLevelsSummed[i] + FirstFiftyLevels[i]);
	#
	#print(FirstFiftyLevelsSummed)
	#return;
