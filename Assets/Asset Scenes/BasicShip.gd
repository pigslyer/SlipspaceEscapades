extends Sprite

onready var tex: AtlasTexture = texture as AtlasTexture;

# negative y values correspond to up, positive to down, 0 to stationary
func SetMovingDirection(dir: Vector2):
	var val = dir.cross(Vector2.RIGHT.rotated(global_rotation));
	
	if (abs(val) < 0.1):
		tex.region.position = Vector2.ZERO;
	elif (val > 0):
		tex.region.position = Vector2(24,0);
	else:
		tex.region.position = Vector2(48,0);
