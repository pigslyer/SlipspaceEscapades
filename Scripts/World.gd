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

class Obj:
	var strength: int = 99999999;

func StopGameplay():
	$GameplayCountdown.stop();
	$Enemies.stop_gameplay();
	$Asteroids.gameplay_stopped = true;
	
	var obj = Obj.new();
	
	for enemy in $Enemies.get_children():
		if enemy.has_method("body_entered"):
			enemy.body_entered(obj);
		elif enemy.has_method("on_body_entered"):
			enemy.on_body_entered(obj);
		
		enemy.set_physics_process(false);

func _on_GameplayCountdown_timeout():
	emit_signal("OnTimerEnded");

func AddScore(amount: int, from):
	emit_signal("OnScoreGained", amount, from);
