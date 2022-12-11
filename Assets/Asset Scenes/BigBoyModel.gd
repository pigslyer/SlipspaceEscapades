extends Node2D

func GetFractalCannonPosition() -> Position2D:
	return $Sprite/FractalCannon as Position2D;

func GetMissileArrayPositions() -> Array:
	return $Sprite/MissileArray.get_children();

func SetMovingDirection(dir: Vector2) -> void:
	$Sprite.texture.region.position = Vector2(sign(dir.y) * 23, 0);
