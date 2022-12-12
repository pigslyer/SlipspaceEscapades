signal attacking()
signal dying()

class_name PlasmaShip
extends Area2D

const SPEED := 100;
const IDLE_DIST := 25;
const BULLET_SCENE := preload("res://Scenes/Bullet.tscn");

export(int) var hp := 3;

onready var left_positions = [$L_1, $L_2, $L_3];
onready var right_positions = [$R_1, $R_2, $R_3];
onready var idle_timer = $IdleTimer;
onready var attack_timer = $AttackTimer;
onready var shoot_timer = $ShootTimer;
onready var viewport_rect = get_viewport().size;

var is_attacking := false;
var starting_position : Vector2;
var is_idle_set := false;
var velocity := Vector2.ZERO;
var go_to : Vector2;
var set_new_x := false;
var y_offset := rand_range(-20, 20);
var can_shoot := false;
var player = null;
var is_on_run := false;
var is_setting_up := false;
var shoot_index := 0;

func _ready():
	go_to.x = rand_range(viewport_rect.x * 0.7, viewport_rect.x * 0.9);
	idle_timer.connect("timeout", self, "set_is_idle_set", [false]);
	attack_timer.connect("timeout", self, "setup_bombing_run");
	starting_position = global_position;

func _physics_process(delta):
	if(is_attacking):
		attack(delta);
	else:
		idle_movement(delta);

func attack(delta):
	if(abs(go_to.y - global_position.y) > 25):
		var diff = go_to - global_position;
		velocity = diff.normalized() * SPEED;
		rotation = 0 if velocity.y < 0 else PI;
		global_position += velocity * delta;
		set_new_x = false;
		
		if(shoot_timer.is_stopped()):
			var new_bullet = BULLET_SCENE.instance();
			new_bullet.rotation = PI;
			
			if(rotation == 0):
				new_bullet.global_position = left_positions[shoot_index].global_position;
			else:
				new_bullet.global_position = right_positions[shoot_index].global_position;
			
			get_parent().add_child(new_bullet);
			shoot_index = (shoot_index + 1) % 3;
			shoot_timer.start();
	elif(!is_setting_up):
		attack_timer.start();
		velocity *= 0;
		is_setting_up = true;

func setup_bombing_run() -> void:
	go_to = Vector2(
		rand_range(viewport_rect.x * 0.8, viewport_rect.x * 0.9),
		viewport_rect.y * 0.9 if global_position.y < viewport_rect.y * 0.5 else viewport_rect.y * 0.1
	);
	is_setting_up = false;

func set_is_idle_set(is_set : bool) -> void:
	is_idle_set = is_set;

func idle_movement(delta) -> void:
	if(!is_idle_set):
		go_to = starting_position;
		go_to += (Vector2.RIGHT * IDLE_DIST).rotated(rand_range(0, 2 * PI));
		
		is_idle_set = true;
	
	if((global_position - go_to).length() < 5):
		if(idle_timer.is_stopped()):
			idle_timer.start();
	else:
		var diff = go_to - global_position;
		velocity = diff.normalized() * SPEED;
		global_position += velocity * delta;

func on_body_entered(entity):
	if(!is_attacking):
		setup_bombing_run();
		is_attacking = true;
		emit_signal("attacking");
	hp -= entity.strength;
	if(hp <= 0):
		emit_signal("dying");
		queue_free();
