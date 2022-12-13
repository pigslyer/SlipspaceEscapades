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

func Explode():
	var tween := create_tween().set_parallel();
	
	tween.tween_callback($Explosion, "Explode", [true, true]).set_delay(rand_range(0.0,0.4));
	tween.tween_callback($Explosion2, "Explode", [true, true]).set_delay(rand_range(0.0,0.4));
