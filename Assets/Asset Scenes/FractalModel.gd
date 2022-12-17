extends Node2D

signal OnExplosionFinished;

func Explode(_target: Node2D):
	$Sprite.hide();
	$Explosion.Explode(false);
	
	yield($Explosion,"OnExplosionFinished");
	emit_signal("OnExplosionFinished");

