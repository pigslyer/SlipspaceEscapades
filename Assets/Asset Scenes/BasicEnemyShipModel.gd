extends Node2D

signal FinishedExploding;

export (AtlasTexture) var texture = null;

func _ready():
	$ExplodableModel.SetModel(texture);

func SetGlobalDirection(dir: Vector2):
	var val = dir.cross(Vector2.RIGHT.rotated(global_rotation));
	
	if (abs(val) < 0.1):
		texture.region.position = Vector2.ZERO;
	elif (val > 0):
		texture.region.position = Vector2(24,0);
	else:
		texture.region.position = Vector2(48,0);

func Hit():
	$ExplodableModel.Hit();

func Explode():
	$ExplodableModel.Destroy();
	
	yield($ExplodableModel,"OnDestroyed");
	emit_signal("FinishedExploding");
