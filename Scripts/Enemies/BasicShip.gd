signal dying()

class_name BasicShip
extends Area2D

const BULLET_SCENE := preload("res://Scenes/Bullet.tscn");
const ANGLE := 0.1;
const ACCELERATION := 40;
const FRICTION := 0.4;
const IDLE_DIST := 50;

onready var viewport_rect = get_viewport().size;
onready var shooting_timer := $ShootingTimer;
onready var idle_timer := $IdleTimer;

var player = null;
var velocity := Vector2.ZERO;
var go_to : Vector2;
var set_new_x := false;
var y_offset := rand_range(-20, 20);
var can_shoot := true;
var hp := 3;
var is_attacking := false;
var starting_position : Vector2;
var is_idle_set := false;

func _ready():
	go_to.x = rand_range(viewport_rect.x * 0.7, viewport_rect.x * 0.9);
	idle_timer.connect("timeout", self, "set_is_idle_set", [false]);
	shooting_timer.connect("timeout", self, "set_can_shoot", [true]);
	starting_position = global_position;

func attack(delta) -> void:
	go_to.y = player.global_position.y + y_offset;
	
	look_at(player.global_position);
	
	if(abs(go_to.y - global_position.y) > 25):
		var diff = go_to - global_position;
		velocity += diff * ACCELERATION * delta;
		velocity *= 1 - FRICTION;
		velocity.x *= 0.1;
		global_position += velocity * delta;
		set_new_x = false;
	elif(!set_new_x):
		go_to.x = rand_range(viewport_rect.x * 0.7, viewport_rect.x * 0.9);
		set_new_x = true;
	else:
		fire();

func fire() -> void:
	if(can_shoot):
		var parent = get_parent();
		
		var new_bullet = BULLET_SCENE.instance();
		new_bullet.rotation = rotation;
		new_bullet.global_position = global_position;
		new_bullet.collision_layer = 128;
		parent.add_child(new_bullet);
		
		var new_bullet1 = BULLET_SCENE.instance();
		new_bullet1.rotation = rotation - ANGLE;
		new_bullet1.global_position = global_position;
		new_bullet1.collision_layer = 128;
		parent.add_child(new_bullet1);
		
		var new_bullet2 = BULLET_SCENE.instance();
		new_bullet2.rotation = rotation + ANGLE;
		new_bullet2.global_position = global_position;
		new_bullet2.collision_layer = 128;
		parent.add_child(new_bullet2);
		
		can_shoot = false;
		shooting_timer.start();

func set_can_shoot(can : bool) -> void:
	can_shoot = can;

func idle_movement(delta) -> void:
	if(!is_idle_set):
		go_to = starting_position;
		go_to += (Vector2.RIGHT * IDLE_DIST).rotated(rand_range(0, 2 * PI));
		
		is_idle_set = true;
	
	var diff = go_to - global_position;
	velocity += diff * ACCELERATION * delta;
	velocity *= 1 - FRICTION;
	global_position += velocity * delta;
	
	if((global_position - go_to).length() < 5 && idle_timer.is_stopped()):
		idle_timer.start();

func set_is_idle_set(is_set : bool) -> void:
	is_idle_set = is_set;

func _physics_process(delta):
	if(is_attacking):
		attack(delta);
	else:
		idle_movement(delta);

func on_body_entered(entity):
	hp -= 1;
	if(hp <= 0):
		emit_signal("dying");
		queue_free();
