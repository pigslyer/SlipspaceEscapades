class_name ExplosiveMissile
extends Area2D

export(int) var strength = 3;

var velocity := Vector2.RIGHT * 500;

onready var timer := $Timer;
onready var explosion_timer := $ExplosionTimer;
onready var visibility_notifier := $VisibilityNotifier2D;
onready var missile_model := $MissileModel;

func _ready():
	explosion_timer.start(rand_range(0.9, 1.1));

func _physics_process(delta):
	global_position += velocity.rotated(rotation) * delta;
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func explode() -> void:
	missile_model.Explode(null);
	set_physics_process(false);
	yield(missile_model, "OnExplosionFinished");
	queue_free();

func multiply(_body_entered = null) -> void:
	yield(get_tree(), "idle_frame");
	
	var angle = 2 * PI / MissilePowerupVariables.explosive_number;
	for i in MissilePowerupVariables.explosive_number:
		var new_bullet = MissilePowerupVariables.BULLET_SCENE.instance();
		get_parent().add_child(new_bullet);
		new_bullet.collision_mask = collision_mask;
		new_bullet.collision_layer = collision_layer;
		new_bullet.rotation = i * angle;
		new_bullet.global_position = global_position;
	
	explode();
