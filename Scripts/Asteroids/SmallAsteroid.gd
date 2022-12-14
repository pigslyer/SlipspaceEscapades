extends Area2D

const MAX_ROTATION_SPEED := 2;
const MAX_SPEED := 20;
const DROP_CHANCE := 0.20;

const POWERUP_ICON_PRELOADS = [
	preload("res://Scenes/PowerupIcons/HealthPowerup.tscn"),
	preload("res://Scenes/PowerupIcons/FractalPowerup.tscn"),
	preload("res://Scenes/PowerupIcons/BFLPowerup.tscn"),
	preload("res://Scenes/PowerupIcons/ExplosivePowerup.tscn"),
	preload("res://Scenes/PowerupIcons/FireratePowerup.tscn"),
	preload("res://Scenes/PowerupIcons/BarragePowerup.tscn"),
	preload("res://Scenes/PowerupIcons/ShieldPowerup.tscn"),
	preload("res://Scenes/PowerupIcons/ArmorPowerup.tscn")
]

export(int) var hp = 5;
export(int) var strength = 2;

onready var visibility_notifier := $VisibilityNotifier2D;
onready var asteroid_model := $AsteroidModel;

var velocity := Vector2();
var rotation_speed := 0.0;
var dir := Vector2.RIGHT;
var was_visible := false;

func _ready():
	velocity = dir * rand_range(0, MAX_SPEED);
	rotation_speed = rand_range(0, MAX_ROTATION_SPEED);

func _physics_process(delta):
	global_position += velocity * delta;
	rotation += rotation_speed * delta;
	
	if(!visibility_notifier.is_on_screen() and was_visible):
		queue_free();
	if(!was_visible and visibility_notifier.is_on_screen()):
		was_visible = true;

func body_entered(entity):
	if!(entity.is_in_group("Entity")):
		hp -= entity.strength;
		if(hp <= 0):
			if(randf() <= DROP_CHANCE):
				var new_index = randi() % Global.POWERUPS.size();
				var player = get_tree().get_nodes_in_group("PLAYER")[0];
				if(player.hp >= player.MAX_HP and new_index == 0):
					while(new_index == 0):
						new_index = randi() % Global.POWERUPS.size();
				
				var new_powerup = POWERUP_ICON_PRELOADS[new_index].instance();
				new_powerup.global_position = global_position;
				get_parent().call_deferred("add_child", new_powerup);
				
			queue_free();
