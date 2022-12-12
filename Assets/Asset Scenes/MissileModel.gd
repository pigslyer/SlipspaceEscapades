extends Node2D

signal OnExplosionFinished;

func Explode(target: Node2D):
	$Trail.emitting = false;
	$Sprite.hide();
	$Explosion.Explode(true);
	
	yield($Explosion,"OnExplosionFinished");
	emit_signal("OnExplosionFinished");

