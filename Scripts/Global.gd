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

var top_left;
var bottom_right;

func get_possible_enemy_pos() -> Vector2:
	var new_pos = Vector2(
		rand_range(top_left.x, bottom_right.x),
		rand_range(top_left.y, bottom_right.y)
	);
	return new_pos;

var _mayExplode: bool = true;

func _process(_delta):
	_mayExplode = true;

func MayExplode() -> bool:
	if (_mayExplode):
		_mayExplode = false;
		return true;
	
	return false;
