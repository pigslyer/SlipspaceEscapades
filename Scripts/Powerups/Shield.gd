class_name Shield
extends Area2D

const MAX_HP := 7;

var hp := 1.0;
var growing := true;

func _physics_process(_delta):
	if(growing):
		var size = hp / MAX_HP;
		scale = Vector2(size, size);
		hp += 0.1 / log(hp + 1);
		growing = hp <= MAX_HP;
	
	if(hp <= 0):
		queue_free();

func bullet_entered(body):
	hp -= 1
	body.queue_free();
