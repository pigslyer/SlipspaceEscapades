class_name Bullet
extends KinematicBody2D

const SPEED := 50;

var velocity : Vector2;

func _init(vel = Vector2.RIGHT):
	velocity = vel;

func _physics_process(_delta):
	move_and_collide(velocity * SPEED);
	
	if(global_position.x > get_viewport_rect().size.x):
		queue_free();
