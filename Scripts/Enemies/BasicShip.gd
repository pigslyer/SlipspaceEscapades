signal attacking()
signal dying()

class_name BasicShip
extends Area2D

const BULLET_SCENE := preload("res://Scenes/Bullet.tscn");
const ANGLE := 0.1;
const SPEED := 150;
const IDLE_DIST := 50;

export(int) var hp := 4;

onready var shooting_timer := $ShootingTimer;
onready var idle_timer := $IdleTimer;

var barrage = false;
var player = null;
var velocity := Vector2.ZERO;
var go_to : Vector2;
var set_new_x := false;
var y_offset := rand_range(-20, 20);
var can_shoot := true;
var is_attacking := false;
var starting_position : Vector2;
var is_idle_set := false;
var gameplay_stopped := false;

func _ready():
	starting_position = Global.get_enemy_starting_pos();
	go_to.x = starting_position.x;
	idle_timer.connect("timeout", self, "set_is_idle_set", [false]);
	shooting_timer.connect("timeout", self, "set_can_shoot", [true]);

func attack(delta) -> void:
	go_to.y = player.global_position.y + y_offset;
	
	look_at(player.global_position);
	
	if(abs(go_to.y - global_position.y) > 25):
		var diff = go_to - global_position;
		velocity = diff.normalized() * SPEED;
		global_position += velocity * delta;
		set_new_x = false;
	elif(!set_new_x):
		go_to.x = Global.get_enemy_starting_pos().x;
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
		
		if(barrage):
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
	if(diff.length() > 5):
		velocity = diff.normalized() * SPEED;
		global_position += velocity * delta;
	
	if((global_position - go_to).length() < 5 && idle_timer.is_stopped()):
		idle_timer.start();

func set_is_idle_set(is_set : bool) -> void:
	is_idle_set = is_set;

func _physics_process(delta):
	if(!gameplay_stopped):
		if(is_attacking):
			attack(delta);
		else:
			idle_movement(delta);
		
		look_at(player.global_position);
	

var _dying := false;

func on_body_entered(entity):
	if(!is_attacking):
		is_attacking = true;
		emit_signal("attacking");
	hp -= entity.strength;
	if(hp <= 0):
		emit_signal("dying");
		
		if entity is Node:
			Global.AddScore(Global.SHIP_SCORES[Global.SHIP_TYPES.BASIC], global_position);
		
		set_deferred("collision_layer",0);
		set_deferred("collision_mask",0);
		$BasicEnemyShipModel.Explode();
		yield($BasicEnemyShipModel,"FinishedExploding");
		
		queue_free();
	else:
		$BasicEnemyShipModel.Hit();



