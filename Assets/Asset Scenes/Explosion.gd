extends Node2D

signal OnExplosionFinished;

func Explode(full: bool):
	if (full):
		$Explosion.emitting = true;
	
	$Smoke.emitting = true;
	$ExplosionTimer.start();


func _on_ExplosionTimer_timeout():
	emit_signal("OnExplosionFinished");
