class_name BigBoy
extends Area2D

const EXPLOSIVE_MISSILE_SCENE := preload("res://Scenes/Powerups/ExplosiveMissile.tscn");
const FRACTAL_MISSILE_SCENE := preload("res://Scenes/Powerups/FractalMissile.tscn");

export(int) var hp = 100;


onready var firing_positions = $BigBoyModel.GetMissileArrayPositions();

onready var fractal_position = $BigBoyModel.GetFractalCannonPosition();
onready var bullet_timer = $BulletTimer;

func _physics_process(delta):
	if(bullet_timer.is_stopped()):
		bullet_timer.start();
		fire_missile(firing_positions[randi() % firing_positions.size()].global_position);

func fire_missile(pos : Vector2):
	var new_missile = EXPLOSIVE_MISSILE_SCENE.instance();
	new_missile.global_position = pos;
	new_missile.collision_layer = 128;
	new_missile.collision_mask = 74;
	new_missile.rotation = PI;
	get_parent().add_child(new_missile);

func fire_fractal() -> void:
	var new_fractal_missile = FRACTAL_MISSILE_SCENE.instance();
	new_fractal_missile.collision_layer = 128;
	new_fractal_missile.collision_mask = 74;
	new_fractal_missile.global_position = fractal_position.global_position;
	new_fractal_missile.rotation = PI;
	get_parent().add_child(new_fractal_missile);
