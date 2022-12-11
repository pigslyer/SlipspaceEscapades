extends Sprite

export (float) var rotationSpeed = 40;

func _process(delta):
	$Generator.global_rotation += deg2rad(rotationSpeed) * delta;

func GetShieldPoopSource() -> Vector2:
	return $Generator.global_position;


