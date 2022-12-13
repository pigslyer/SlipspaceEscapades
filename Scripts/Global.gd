extends Node

enum POWERUPS{
	HEALTH = 1, 
	FRACTAL = 2, 
	BFL = 4,
	EXPLOSIVE = 8, 
	FIRERATE = 16, 
	BARRAGE = 32, 
	SHIELD = 64, 
	ARMOR = 128,
}

var _mayExplode: bool = true;

func _process(_delta):
	_mayExplode = true;

func MayExplode() -> bool:
	if (_mayExplode):
		_mayExplode = false;
		return true;
	
	return false;
