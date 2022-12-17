extends Node2D

signal OnTimerEnded;
signal OnScoreGained(amount, from);

func _ready():
	Global.enemy_start_top_left = $Enemies/EnemyStartingArea/TopLeft.global_position;
	Global.enemy_start_bottom_right = $Enemies/EnemyStartingArea/BottomRight.global_position;
	$Enemies.countdown_timer = $GameplayCountdown;

func StartGameplay(time: float):
	$GameplayCountdown.start(time);
	$Enemies.gameplay_stopped = false;
	$Asteroids.gameplay_stopped = false;

func StopGameplay():
	$GameplayCountdown.stop();
	$Enemies.stop_gameplay();
	$Asteroids.gameplay_stopped = true;
	
	for enemy in $Enemies.get_children():
		enemy.set_physics_process(false);

func _on_GameplayCountdown_timeout():
	emit_signal("OnTimerEnded");

func AddScore(amount: int, from):
	emit_signal("OnScoreGained", amount, from);
