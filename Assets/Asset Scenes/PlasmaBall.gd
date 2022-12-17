extends Node2D

signal OnExplosionFinished;

func Explode(_target: Node2D):
	$Trail.emitting = false;
	$Sprite.hide();
	$Explosion.Explode(true);
	
	yield($Explosion,"OnExplosionFinished");
	emit_signal("OnExplosionFinished");

