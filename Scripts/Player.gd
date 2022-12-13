class_name Player
extends KinematicBody2D

signal OnPlayedDied;

#CONSTANTS FOR MOVEMENT
const ACCELERATION := 2500;
const FRICTION := 0.2;

#SCENE CONSTANTS
var BULLET_TYPES_SCENES := [
	MissilePowerupVariables.BULLET_SCENE,
	MissilePowerupVariables.EXPLOSIVE_MISSILE_SCENE,
	MissilePowerupVariables.FRACTAL_MISSILE_SCENE,
	preload("res://Scenes/Powerups/BFL.tscn")
];
const SHIELD_SCENE := preload("res://Scenes/Powerups/Shield.tscn");

#POWERUP CONSTANTS
const MAX_HP = 3;
const BFL_TIME = 5;
const BULLET_SPACING = (2 * PI + 0.07) * 0.01;
const SHIELD_POOPS_AMOUNT = 3;
enum BULLET_TYPES {
	NORMAL,
	EXPLOSIVE,
	FRACTAL,
	BFL
};

#POWERUP CHILD NODES
onready var firing_position := $FiringPosition;
onready var shooting_timer := $ShootingTimer;
onready var shield_pooper_timer := $ShieldPooperTimer;
onready var bfl_timer := $BFLTimer;
onready var bfls := $BFLS;

#MOVEMENT VARIABLES
var velocity := Vector2.ZERO;

#INPUTS
var input := Vector2.ZERO;
var shoot := false;
var can_shoot := true;
var restrict_shooting := false;
var test_powerup := false;

#POWERUP VARIABLES
var hps := 3;
var armor := 0;
var powerups := {
	"barrage": 0,
	"fire_rate": 0,
	"explosive_rounds": 0
};
var remaining_poop_shields = 0;


var _controlsLocked = false;

func SetControlsLocked(state: bool):
	_controlsLocked = state;


func _ready():
	shooting_timer.connect("timeout", self, "set_can_shoot", [true]);
	bfl_timer.connect("timeout", self, "set_can_shoot", [true]);
	bfl_timer.connect("timeout", self, "clear_bfls");
	bfl_timer.connect("timeout", self, "set_restrict_shoting", [false]);
	shield_pooper_timer.connect("timeout", self, "poop_shields");

func _physics_process(delta):
	check_input();
	
	velocity += input * ACCELERATION * delta;
	velocity *= 1 - FRICTION;
	
	$BasicShip.SetMovingDirection(input);
	
	velocity = move_and_slide(velocity, Vector2.UP);
	
	if(can_shoot && shoot):
		fire_bullet(BULLET_TYPES.NORMAL);
		can_shoot = false;
		shooting_timer.start(1.0/(2*powerups["fire_rate"]+10));
	
	if(test_powerup && can_shoot):
		fire_bullet(BULLET_TYPES.FRACTAL);
	
	if (!_controlsLocked):
		look_at(get_global_mouse_position());

func fire_bullet(bullet_type) -> void:
	var bullet_type_scene = BULLET_TYPES_SCENES[bullet_type];
	var parent = get_parent();
	
	var new_bullet = bullet_type_scene.instance();
	new_bullet.global_position = firing_position.global_position;
	new_bullet.collision_layer = 64;
	new_bullet.rotation = rotation;
	parent.add_child(new_bullet);
	
	for i in powerups["barrage"]:
		var angle = (i + 1) * BULLET_SPACING;
		
		var new_bullet1 = bullet_type_scene.instance();
		new_bullet1.rotation = rotation + angle;
		new_bullet1.global_position = firing_position.global_position;
		new_bullet1.collision_layer = 64;
		parent.add_child(new_bullet1);
		
		var new_bullet2 = bullet_type_scene.instance();
		new_bullet2.rotation = rotation - angle;
		new_bullet2.global_position = firing_position.global_position;
		new_bullet2.collision_layer = 64;
		parent.add_child(new_bullet2);

func check_input() -> void:
	if (_controlsLocked):
		input = Vector2.ZERO;
		shoot = false;
		test_powerup = false;
	
	else:
		input = Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		);
		
		shoot = Input.is_action_pressed("shoot");
		test_powerup = Input.is_action_just_pressed("test_powerup");

func fire_BFL() -> void:
	restrict_shooting = true;
	can_shoot = false;
	
	var bfl_scene = BULLET_TYPES_SCENES[BULLET_TYPES.BFL];
	
	var new_bfl = bfl_scene.instance();
	new_bfl.position = firing_position.position;
	bfls.add_child(new_bfl);
	
	for i in powerups["barrage"]:
		var angle = (i + 1) * BULLET_SPACING;
		
		var new_bfl1 = bfl_scene.instance();
		new_bfl1.rotation = angle;
		new_bfl1.position = firing_position.position;
		bfls.add_child(new_bfl1);
		
		var new_bfl2 = bfl_scene.instance();
		new_bfl2.rotation = -angle;
		new_bfl2.position = firing_position.position;
		bfls.add_child(new_bfl2);
	
	bfl_timer.start(BFL_TIME);

func clear_bfls() -> void:
	for child in bfls.get_children():
		child.queue_free();

func poop_shields() -> void:
	if(remaining_poop_shields > 0):
		var new_shield = SHIELD_SCENE.instance();
		new_shield.global_position = global_position;
		get_parent().add_child(new_shield);
		
		remaining_poop_shields = remaining_poop_shields - 1;
		shield_pooper_timer.start();

func set_restrict_shoting(can : bool) -> void:
	restrict_shooting = can;

func set_can_shoot(can : bool) -> void:
	if(!restrict_shooting && can_shoot == false):
		can_shoot = can;
