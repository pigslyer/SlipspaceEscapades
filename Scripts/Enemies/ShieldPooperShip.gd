class_name ShieldPooperShip
extends Area2D

const ROTATION_SPEED = PI * 1.4;

const SPEED := 50;
const SHIELD_SCENE := preload("res://Scenes/Powerups/Shield.tscn");
const SHIELD_POOP_SPEED := 500;
const MAX_POOPED := 3;

onready var movement_timer := $MovementTimer;
onready var shield_poop_timer := $ShieldPoopTimer;

export(int) var hp := 5;

var velocity := Vector2();
var go_to := Vector2();
var pooped := 0;
var player;
var angle_of_poop := 0.0;

func _ready():
	go_to = global_position;
	movement_timer.connect("timeout", self, "set_new_go_to");
	look_at(get_tree().get_nodes_in_group("PLAYER")[0].global_position);

func _physics_process(delta):
	var diff = go_to - global_position;
	if(diff.length() > 5):
		velocity = diff.normalized() * SPEED;
		global_position += velocity * delta;
	elif(movement_timer.is_stopped()):
		movement_timer.start();
		pooped = 0;
		angle_of_poop = rand_range(0, 2 * PI);
	elif(pooped < MAX_POOPED and shield_poop_timer.is_stopped()):
		pooped += 1;
		poop_shield();
		shield_poop_timer.start();

func _process(delta):
	if (velocity.length_squared() > 0):
		rotation = lerp_angle(rotation, velocity.angle(), ROTATION_SPEED * delta);

func poop_shield() -> void:
	var angle = 2 * PI * pooped / MAX_POOPED;
	
	var new_shield = SHIELD_SCENE.instance();
	new_shield.collision_mask = 64;
	new_shield.global_position = $ShieldPooperModel.GetShieldPoopSource();
	new_shield.velocity = (Vector2.RIGHT * SHIELD_POOP_SPEED).rotated(angle + angle_of_poop);
	get_parent().add_child(new_shield);

func set_new_go_to() -> void:
	go_to = Global.get_possible_enemy_pos();

func body_entered(entity):
	hp -= entity.strength;
	if(hp <= 0):
		queue_free();
