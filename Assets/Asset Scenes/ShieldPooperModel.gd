extends Sprite

signal OnDestroyed;

export (float) var rotationSpeed = 40.0;

onready var generator: Sprite = $Generator;

func _process(delta):
	generator.global_rotation += deg2rad(rotationSpeed) * delta;

func GetShieldPoopSource() -> Vector2:
	if is_processing():
		return generator.global_position;
	return global_position;

func Hit():
	$ExplodableModel.Hit();

func Destroy():
	set_process(false);
	set_deferred("collision_layer",0);
	set_deferred("collision_mask",0);
	if generator != null:
		generator.queue_free();
		generator = null;
	$ExplodableModel.Destroy();
	yield($ExplodableModel,"OnDestroyed");
	emit_signal("OnDestroyed");
