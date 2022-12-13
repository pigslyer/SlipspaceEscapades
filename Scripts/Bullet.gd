class_name Bullet
extends Area2D

const SPEED := 400;

export(int) var strength = 1;

onready var visibility_notifier := $VisibilityNotifier2D;

var velocity : Vector2;

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * SPEED * delta;
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func explode(area):
	set_physics_process(false);
	$Plasma.Explode(area);
	yield($Plasma,"OnExplosionFinished");
	queue_free();

func area_entered(area):
	explode(area);
