extends Node2D

signal OnExplosionFinished;

func GetFractalCannonPosition() -> Position2D:
	return $ExplodableModel/FractalCannon as Position2D;

func GetMissileArrayPositions() -> Array:
	return $ExplodableModel/MissileArray.get_children();

func SetMovingDirection(dir: Vector2) -> void:
	$ExplodableModel.model.region.position = Vector2(sign(dir.y) * 23, 0);

func _ready():
	set_process(false);

func Hit():
	set_process(true);
	$ShakeTime.start();
	$ShakeInterval.start();
	$ExplodableModel.Hit();

func Shake():
	position = Vector2(rand_range(-2,2), rand_range(-2, 2));

func StopHit():
	$ShakeInterval.stop();

func Explode():
	$ExplodableModel.Destroy();
	yield($ExplodableModel, "OnDestroyed");
	emit_signal("OnExplosionFinished");
