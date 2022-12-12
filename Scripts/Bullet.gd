class_name Bullet
extends KinematicBody2D

const SPEED := 400;

onready var visibility_notifier := $VisibilityNotifier2D;

var velocity : Vector2;

func _init(vel = Vector2.RIGHT):
	velocity = vel;

func _physics_process(delta):
	move_and_collide(velocity.rotated(rotation) * SPEED * delta);
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func OnCollision(entity):
	set_physics_process(false);
	$Plasma.Explode(entity);
	
	yield($Plasma,"OnExplosionFinished");
	queue_free();
