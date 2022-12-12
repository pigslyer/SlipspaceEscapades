extends Node2D

signal OnExplosionFinished;

func Explode(target: Node2D):
	$Sprite.hide();
	$Explosion.Explode(false);
	
	yield($Explosion,"OnExplosionFinished");
	emit_signal("OnExplosionFinished");

