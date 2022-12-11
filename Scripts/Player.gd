class_name Player
extends KinematicBody2D

#CONSTANTS FOR MOVEMENT
const ACCELERATION := 2500;
const FRICTION := 0.2;

#CONSTANT FOR USE
const BULLET_SCENE := preload("res://Scenes/Bullet.tscn");
const BULLET_SPACING = (2 * PI + 0.01) * 0.01;

onready var firing_position := $FiringPosition;
onready var shooting_timer := $ShootingTimer;

#INPUTS
var input := Vector2.ZERO;
var shoot := false;
var can_shoot := true;

var velocity := Vector2.ZERO;

var hps := 3;
var armor := 0;
var powerups := {
	"barrage": 0,
	"fire_rate": 0,
	"explosive_rounds": 0
};

func _ready():
	shooting_timer.connect("timeout", self, "set_can_shoot", [true]);

func _physics_process(delta):
	check_input();
	
	velocity += input * ACCELERATION * delta;
	velocity *= 1 - FRICTION;
	
	$BasicShip.SetMovingDirection(input);
	
	velocity = move_and_slide(velocity, Vector2.UP);
	
	if(can_shoot && shoot):
		fire_bullet();
		can_shoot = false;
		shooting_timer.start(1.0/(2*powerups["fire_rate"]+10));

func fire_bullet() -> void:
	var new_bullet = BULLET_SCENE.instance();
	new_bullet.global_position = firing_position.global_position;
	get_parent().add_child(new_bullet);
	
	for i in powerups["barrage"]:
		var angle = (i + 1) * BULLET_SPACING;
		
		var new_bullet1 = BULLET_SCENE.instance();
		new_bullet1._init(Vector2.RIGHT.rotated(angle));
		new_bullet1.global_position = firing_position.global_position;
		get_parent().add_child(new_bullet1);
		
		var new_bullet2 = BULLET_SCENE.instance();
		new_bullet2._init(Vector2.RIGHT.rotated(-angle));
		new_bullet2.global_position = firing_position.global_position;
		get_parent().add_child(new_bullet2);

func check_input() -> void:
	var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	
	input.x = horizontal;
	input.y = vertical;
	
	shoot = Input.is_action_pressed("shoot");

func set_can_shoot(can : bool) -> void:
	can_shoot = can;
