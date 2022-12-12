class_name Bullet
extends Area2D

const SPEED := 400;

export(int) var strength = 1;

onready var visibility_notifier := $VisibilityNotifier2D;
onready var spawn_timer := $SpawnTimer;

var velocity : Vector2;
var coll_layer;
var m_layer;

func _ready():
	coll_layer = collision_layer;
	m_layer = collision_mask;
	
	collision_layer = 0;
	collision_mask = 0;
	
	spawn_timer.connect("timeout", self, "enable_layers");
	spawn_timer.start();

func enable_layers() -> void:
	collision_layer = coll_layer;
	collision_mask = m_layer;

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
