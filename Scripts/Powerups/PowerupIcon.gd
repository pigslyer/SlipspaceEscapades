extends Area2D

export(Global.POWERUPS) var powerup_type;

func _ready():
	$PowerupIcons.ShowIcon(powerup_type);

func player_entered(player):
	player.get_parent().add_powerup(powerup_type);
	queue_free();
