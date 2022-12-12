class_name FractalMissile
extends Area2D

const SPEED := 250;

export(int) var strength = 10;

onready var visibility_notifier := $VisibilityNotifier2D;
onready var timer := $Timer;
onready var spawn_timer := $SpawnTimer;
onready var fractal_model := $FractalModel;

var level := 0;
var m_layer;
var c_layer;

func _ready():
	timer.connect("timeout", self, "multiply");
	timer.start(MissilePowerupVariables.FRACTAL_TIME);
	
	m_layer = collision_mask;
	c_layer = collision_layer;
	
	collision_layer = 0;
	collision_mask = 0;
	
	spawn_timer.connect("timeout", self, "enable_layers");
	spawn_timer.start();

func enable_layers() -> void:
	collision_layer = c_layer;
	collision_mask = m_layer;

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * SPEED * delta;
	
	if(!visibility_notifier.is_on_screen()):
		queue_free();

func explode(area) -> void:
	fractal_model.Explode(area);
	set_physics_process(false);
	yield(fractal_model, "OnExplosionFinished");
	queue_free();

func multiply(area = null) -> void:
	yield(get_tree(), "idle_frame");
	
	if(level < MissilePowerupVariables.FRACTAL_LEVELS):
		var angle = 2 * PI / MissilePowerupVariables.FRACTAL_NUMBER;
		
		for i in MissilePowerupVariables.FRACTAL_NUMBER:
			var new_fractal_missile;
			if(level < MissilePowerupVariables.FRACTAL_LEVELS - 1):
				new_fractal_missile = MissilePowerupVariables.FRACTAL_MISSILE_SCENE.instance();
				new_fractal_missile.strength = max(strength - 1, 1);
				new_fractal_missile.level = level + 1;
			else:
				new_fractal_missile = MissilePowerupVariables.EXPLOSIVE_MISSILE_SCENE.instance();
			get_parent().add_child(new_fractal_missile);
			new_fractal_missile.timer.start(MissilePowerupVariables.FRACTAL_TIME * 0.2);
			new_fractal_missile.scale *= 0.8;
			new_fractal_missile.global_rotation = i * angle;
			new_fractal_missile.global_position = global_position;
	
		explode(area);
