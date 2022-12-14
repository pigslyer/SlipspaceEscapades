extends Area2D

export(Global.POWERUPS) var powerup_type;

const ACCELERATION := 10;

onready var visibility_notifier := $VisibilityNotifier2D;

var was_visible := false;
var velocity := Vector2();

func _ready():
	$PowerupIcons.ShowIcon(powerup_type);

func _physics_process(delta):
	if(was_visible and !visibility_notifier.is_on_screen()):
		queue_free();
	if(visibility_notifier.is_on_screen() and !was_visible):
		was_visible = true;
	
	velocity.x -= ACCELERATION * delta;
	global_position += velocity * delta;

func player_entered(player):
	player.get_parent().add_powerup(powerup_type);
	queue_free();
