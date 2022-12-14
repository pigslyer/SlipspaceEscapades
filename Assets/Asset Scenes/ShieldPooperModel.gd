extends Sprite

signal OnDestroyed;

export (float) var rotationSpeed = 40;

func _process(delta):
	$Generator.global_rotation += deg2rad(rotationSpeed) * delta;

func GetShieldPoopSource() -> Vector2:
	if is_processing():
		return $Generator.global_position;
	return global_position;

func Hit():
	$ExplodableModel.Hit();

func Destroy():
	set_process(false);
	set_deferred("collision_layer",0);
	set_deferred("collision_mask",0);
	$Generator.queue_free();
	$ExplodableModel.Destroy();
	yield($ExplodableModel,"OnDestroyed");
	emit_signal("OnDestroyed");
