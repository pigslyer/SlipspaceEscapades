class_name Shield
extends Area2D

const FRICTION := 0.1;

export(int) var max_hp := 7;

onready var pussy_timer := $PussyTimer;

var hp := 1.0;
var growing := true;
var velocity := Vector2();

func _ready():
	scale = Vector2.ZERO;
	$Shield.material.set_shader_param("t0", OS.get_ticks_msec());

func _physics_process(delta):
	if(growing):
		var size = hp / max_hp;
		scale = Vector2(size, size);
		hp += 0.1/(hp+1);
		_updateShaderTear();
		growing = hp <= max_hp;
	
	velocity *= 1 - FRICTION;
	global_position += velocity * delta;

func bullet_entered(body):
	if(pussy_timer.is_stopped()):
		if(collision_mask & 136 == 136):
			hp -= 1
		else:
			hp -= body.strength;
		_updateShaderTear();
		pussy_timer.start();
		growing = false;
		
		if(hp <= 0):
			queue_free();

func DestroyShield():
	hp = 0;
	_updateShaderTear();
	yield(get_tree().create_timer($PussyTimer.wait_time + 0.1), "timeout");
	queue_free();

func _updateShaderTear():
	create_tween().tween_method(
		self, 
		"_uselessMethod", 
		$Shield.material.get_shader_param("fade_away_perc"),
		1 - float(hp) / max_hp,
		$PussyTimer.wait_time
	).set_trans(Tween.TRANS_CUBIC);


func _uselessMethod(val: float):
	$Shield.material.set_shader_param("fade_away_perc", val);
