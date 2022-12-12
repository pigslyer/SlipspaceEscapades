extends Node2D

signal OnTimerEnded;

func StartGameplay(time: float):
	$GameplayCountdown.start(time);

func StopGameplay():
	pass


func _on_GameplayCountdown_timeout():
	emit_signal("OnTimerEnded");
