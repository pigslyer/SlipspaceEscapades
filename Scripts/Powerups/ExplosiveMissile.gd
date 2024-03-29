class_name ExplosiveMissile
extends Area2D

const SPEED := 400;

export(int) var strength = 2;

onready var timer := $Timer;
onready var explosion_timer := $ExplosionTimer;
onready var visibility_notifier := $VisibilityNotifier2D;
onready var missile_model := $MissileModel;

func _ready():
	explosion_timer.start(rand_range(0.9, 1.1));

func _physics_process(delta):
	global_position += (Vector2.RIGHT * SPEED).rotated(rotation) * delta;
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func explode(_area = null) -> void:
	missile_model.Explode(null);
	set_physics_process(false);
	set_deferred("collision_layer", 0);
	set_deferred("collision_mask", 0);
	yield(missile_model, "OnExplosionFinished");
	queue_free();

func multiply(_body_entered = null) -> void:
		
	var angle = 2 * PI / MissilePowerupVariables.explosive_number;
	for i in MissilePowerupVariables.explosive_number:
		var new_bullet = MissilePowerupVariables.BULLET_SCENE.instance();
		get_parent().add_child(new_bullet);
		new_bullet.collision_mask = collision_mask;
		new_bullet.collision_layer = collision_layer;
		new_bullet.strength = MissilePowerupVariables.explosive_strength;
		new_bullet.rotation = rotation + i * angle;
		new_bullet.global_position = global_position;
	
	explode();
