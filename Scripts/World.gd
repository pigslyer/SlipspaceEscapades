extends Node2D

signal OnTimerEnded;
signal OnScoreGained(amount, from);

func _ready():
	Global.top_left = $EnemyStartingArea/TopLeft.global_position;
	Global.bottom_right = $EnemyStartingArea/BottomRight.global_position;
	$Enemies.countdown_timer = $GameplayCountdown;

func StartGameplay(time: float):
	$GameplayCountdown.start(time);

func StopGameplay():
	$GameplayCountdown.stop();
	
	for enemy in $Enemies.get_children():
		enemy.set_physics_process(false);

func _on_GameplayCountdown_timeout():
	emit_signal("OnTimerEnded");

func AddScore(amount: int, from):
	emit_signal("OnScoreGained", amount, from);
