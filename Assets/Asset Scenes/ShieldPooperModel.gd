extends Sprite

signal OnDestroyed;

export (float) var rotationSpeed = 40;

func _process(delta):
	$Generator.global_rotation += deg2rad(rotationSpeed) * delta;

func GetShieldPoopSource() -> Vector2:
	return $Generator.global_position;

func Hit():
	$ExplodableModel.Hit();

func Destroy():
	$Generator.queue_free();
	$ExplodableModel.Destroy();
	yield($ExplodableModel,"OnDestroyed");
	emit_signal("OnDestroyed");
