extends Node2D

var RingRadius : int = 0;

func MakeMarkerRing(_number : int, _radius = RingRadius) -> void:
	var AngleIncrement : float = 2*PI/_number;
	
	for i in range(0, _number):
		var NewMarker : Marker2D = Marker2D.new();
		self.add_child(NewMarker);
		NewMarker.position = Vector2(self.position.x + _radius * cos(AngleIncrement * i), self.position.y + _radius * sin(AngleIncrement * i));
		continue;
	return;

func AddWeaponSpritesToMarker(_weaponArray : Array[Node], _radius = RingRadius) -> void:
	ClearMarkers();
	var NumberOfWeapons : int = len(_weaponArray);
	if (NumberOfWeapons == 0): return;
	
	MakeMarkerRing(NumberOfWeapons, _radius);
	for i in range(len(self.get_children())):
		var WeaponToPut : Node = _weaponArray[i];
		var Marker : Marker2D = self.get_child(i);
		
		#var NewSprite : Sprite2D = Sprite2D.new();
		var NewSprite = WeaponToPut.MarkerSprite;
		NewSprite.texture = WeaponToPut.Stats.Sprite;
		#WeaponToPut.add_child(NewSprite);
		NewSprite.position = Marker.position;
		
		WeaponToPut.MarkerSprite = NewSprite;
		continue;
	return;

func ClearMarkers() -> void:
	for _marker in self.get_children():
		_marker.queue_free();
		continue;
	return;
