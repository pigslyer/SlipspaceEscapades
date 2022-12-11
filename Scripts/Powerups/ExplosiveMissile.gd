class_name ExplosiveMissile
extends Area2D

const offset := Vector2.RIGHT * 25;

var velocity := Vector2.RIGHT * 500;
var can_multiply := true;

onready var timer := $Timer;
onready var visibility_notifier := $VisibilityNotifier2D;

func _physics_process(delta):
	global_position += velocity.rotated(rotation) * delta;
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func explode() -> void:
	queue_free();

func multiply(_body_entered) -> void:
	if(can_multiply):
		yield(get_tree(), "idle_frame");
		var variables := get_node("/root/MissilePowerupVariables");
		
		var angle = 2 * PI / variables.explosive_number;
		for i in variables.explosive_number:
			var new_explosive_missile = variables.EXPLOSIVE_MISSILE_SCENE.instance();
			get_parent().add_child(new_explosive_missile);
			new_explosive_missile.scale *= 0.5;
			new_explosive_missile.velocity = velocity.rotated(i * angle) * 0.5;
			new_explosive_missile.rotation = i * angle;
			new_explosive_missile.global_position = global_position + offset.rotated(i * angle);
			new_explosive_missile.timer.connect("timeout", new_explosive_missile, "explode");
			new_explosive_missile.timer.start(variables.explosive_time);
			new_explosive_missile.can_multiply = false;
	
	explode();
