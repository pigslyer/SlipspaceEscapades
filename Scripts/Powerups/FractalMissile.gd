class_name FractalMissile
extends Area2D

const offset := Vector2.RIGHT * 10;

onready var visibility_notifier := $VisibilityNotifier2D;
onready var timer := $Timer;

var velocity := Vector2.RIGHT * 250;
var level := 0;

func _ready():
	var variables := get_node("/root/MissilePowerupVariables");
	timer.connect("timeout", self, "multiply");
	timer.start(variables.FRACTAL_TIME);

func _physics_process(delta):
	global_position += velocity.rotated(rotation) * delta;
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func explode(entity = null) -> void:
	queue_free();

func multiply() -> void:
	var variables := get_node("/root/MissilePowerupVariables");
	
	if(level < variables.FRACTAL_LEVELS):
		
		var angle = 2 * PI / variables.FRACTAL_NUMBER;
		
		for i in variables.FRACTAL_NUMBER:
			var new_fractal_missile = variables.FRACTAL_MISSILE_SCENE.instance();
			get_parent().add_child(new_fractal_missile);
			new_fractal_missile.scale *= 0.5;
			new_fractal_missile.velocity = velocity.rotated(i * angle) * 1.2;
			new_fractal_missile.rotation = i * angle;
			new_fractal_missile.global_position = global_position + offset.rotated(i * angle);
			new_fractal_missile.level = level + 1;
			new_fractal_missile.timer.start(variables.FRACTAL_TIME * 0.2);
	
		explode();
