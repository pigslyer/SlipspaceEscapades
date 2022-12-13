extends Node2D

signal OnTimerEnded;

func _ready():
	Global.top_left = $EnemySpawnArea/TopLeft.global_position;
	Global.bottom_right = $EnemySpawnArea/BottomRight.global_position;
	$Enemies.countdown_timer = $GameplayCountdown;

func StartGameplay(time: float):
	$GameplayCountdown.start(time);

func StopGameplay():
	pass

func _on_GameplayCountdown_timeout():
	emit_signal("OnTimerEnded");
