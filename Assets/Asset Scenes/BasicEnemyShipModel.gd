extends Node2D

export (AtlasTexture) var other = null;

func _ready():
	if other != null:
		$Sprite.texture = other;

func SetGlobalDirection(dir: Vector2):
	var val = dir.cross(Vector2.RIGHT.rotated(global_rotation));
	
	if (abs(val) < 0.1):
		$Sprite.texture.region.position = Vector2.ZERO;
	elif (val > 0):
		$Sprite.texture.region.position = Vector2(24,0);
	else:
		$Sprite.texture.region.position = Vector2(48,0);

