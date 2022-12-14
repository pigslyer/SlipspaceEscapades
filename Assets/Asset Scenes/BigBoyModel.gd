extends Node2D

signal OnExplosionFinished;

func GetFractalCannonPosition() -> Position2D:
	return $ExplodableModel/FractalCannon as Position2D;

func GetMissileArrayPositions() -> Array:
	return $ExplodableModel/MissileArray.get_children();

func SetMovingDirection(dir: Vector2) -> void:
	$ExplodableModel.model.region.position = Vector2(sign(dir.y) * 23, 0);

func Hit():
	$ExplodableModel.Hit();

func Explode():
	$ExplodableModel.Destroy();
	yield($ExplodableModel, "OnDestroyed");
	emit_signal("OnExplosionFinished");
