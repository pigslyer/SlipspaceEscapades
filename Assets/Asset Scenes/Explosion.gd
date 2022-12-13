extends Node2D

signal OnExplosionFinished;

const EXPLOSION_SOUNDS = [
	preload("res://Assets/SFX/GenericExplosion1.ogg"),
	preload("res://Assets/SFX/GenericExplosion2.wav"),
	preload("res://Assets/SFX/GenericExplosion3.ogg"),
];

func Explode(full: bool):
	if (Global.MayExplode()):
		if (full):
			$Explosion.emitting = true;
			Sounds.PlaySound(EXPLOSION_SOUNDS[randi() % EXPLOSION_SOUNDS.size()], null, -8, rand_range(0.8, 1.2));
		
		$Smoke.emitting = true;
	
	$ExplosionTimer.start();


func _on_ExplosionTimer_timeout():
	emit_signal("OnExplosionFinished");
