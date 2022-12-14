signal attacking()
signal dying()

class_name PlasmaShip
extends Area2D

const SPEED := 100;
const IDLE_DIST := 25;
const BULLET_SCENE := preload("res://Scenes/Bullet.tscn");

export(int) var hp := 3;

onready var left_positions = $PlasmaSiegeShip/LeftSide.get_children();
onready var right_positions = $PlasmaSiegeShip/RightSide.get_children();
onready var idle_timer = $IdleTimer;
onready var attack_timer = $AttackTimer;
onready var shoot_timer = $ShootTimer;

var is_attacking := false;
var starting_position : Vector2;
var is_idle_set := false;
var velocity := Vector2.ZERO;
var go_to : Vector2;
var set_new_x := false;
var y_offset := rand_range(-20, 20);
var can_shoot := false;
var is_on_run := false;
var is_setting_up := false;
var shoot_index := 0;
var gameplay_stopped := false;

func _ready():
	starting_position = Global.get_enemy_starting_pos();
	go_to.x = starting_position.x;
	idle_timer.connect("timeout", self, "set_is_idle_set", [false]);
	attack_timer.connect("timeout", self, "setup_bombing_run");

func _physics_process(delta):
	if(!gameplay_stopped):
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
			new_bullet.collision_layer = 128;
			
			if(rotation == 0):
				new_bullet.global_position = left_positions[shoot_index].global_position;
			else:
				new_bullet.global_position = right_positions[shoot_index].global_position;
			
			get_parent().add_child(new_bullet);
			shoot_index = (shoot_index + 1) % 3;
			shoot_timer.start();
	elif(!is_setting_up):
		var tween := create_tween();
		tween.tween_property(self, "rotation", rotation + PI, attack_timer.wait_time * 0.8).set_trans(Tween.TRANS_CUBIC);
		attack_timer.start();
		is_setting_up = true;

func setup_bombing_run() -> void:
	go_to.x = Global.get_enemy_starting_pos().x;
	go_to.y = Global.enemy_start_bottom_right.y if global_position.y < Global.enemy_start_bottom_right.y * 0.5 else Global.enemy_start_bottom_right.y * 0.1;
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
		if(diff.length() > 5):
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
		$PlasmaSiegeShip.Destroy();
		
		set_deferred("collision_layer",0);
		set_deferred("collision_mask",0);
		yield($PlasmaSiegeShip,"OnDestroyed");
		queue_free();
	else:
		$PlasmaSiegeShip.Hit();
