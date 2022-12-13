class_name Shield
extends Area2D

const FRICTION := 0.1;

export(int) var max_hp := 7;

var hp := 1.0;
var growing := true;
var velocity := Vector2();

func _physics_process(delta):
	if(hp <= 0):
		queue_free();
	
	if(growing):
		var size = hp / max_hp;
		scale = Vector2(size, size);
		hp += 1/hp;
		growing = hp <= max_hp;
	
	velocity *= 1 - FRICTION;
	global_position += velocity * delta;

func bullet_entered(body):
	hp -= body.strength;
	growing = false;
	if(hp <= 0):
		queue_free();
