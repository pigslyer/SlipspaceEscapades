extends Node

const BIG_ASTEROID_SCORE = 1000;
const SMALL_ASTEROID_SCORE = 100;
const BIG_BOY_SCORE = 5000;
const POWERUP_SCORE = 1000;

func _ready():
	VisualServer.set_default_clear_color(Color.black);
	
	if get_tree().current_scene.name == "BiggerWorld":
		Input.set_custom_mouse_cursor(preload("res://Assets/Sprites/MouseIcon.png"), Input.CURSOR_ARROW, Vector2(12,12));
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	

enum SHIP_TYPES {
	BASIC,
	BASIC_VARIANT,
	PLASMA,
	BIG_BOY,
	SHIELD_POOPER
};

const SHIP_SCORES = [
	100,
	250,
	500,
	10000,
	500,
];


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

var HUD;

func AddScore(amount: int, pos: Vector2 = Vector2(-1,-1)):
	if (HUD != null):
		HUD.OnScoreGained(amount, pos);


var enemy_start_top_left;
var enemy_start_bottom_right;

func get_enemy_starting_pos() -> Vector2:
	var new_pos = Vector2(
		rand_range(enemy_start_top_left.x, enemy_start_bottom_right.x),
		rand_range(enemy_start_top_left.y, enemy_start_bottom_right.y)
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
