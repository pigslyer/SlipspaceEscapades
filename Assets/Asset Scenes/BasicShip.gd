extends Node2D

onready var tex: AtlasTexture = $ExplodableModel.model as AtlasTexture;
onready var _firingPos = $FiringPos;

export (float) var invulnFlashLength = 0.2;
export (float) var invulnLength = 0.6;

func _ready():
	$ExplodableModel.iframeFlashLength = invulnFlashLength;
	$ExplodableModel.iframeLength = invulnLength;

func FireThrusters(slow: bool):
	var selected: Node2D = $SlowTrails if slow else $FastTrails; 
	
	for child in selected.get_children():
		child.Start();
	
#	if (slow):
#		yield(selected.get_child(0), "OnTrailFinished");
#
#		var tween := create_tween().set_trans(Tween.TRANS_CUBIC);
#		tween.tween_property(self, "position", position + Vector2(40, 0), 0.2).set_trans(Tween.TRANS_BOUNCE);
#		tween.tween_property(self, "position", position, 1.8).set_delay(0.8);
	

func GetFiringPos() -> Vector2:
	return _firingPos.global_position;

# negative y values correspond to up, positive to down, 0 to stationary
func SetMovingDirection(dir: Vector2):
	var val = dir.cross(Vector2.RIGHT.rotated(global_rotation));
	
	if (abs(val) < 0.04):
		tex.region.position = Vector2.ZERO;
	elif (val > 0):
		tex.region.position = Vector2(24,0);
	else:
		tex.region.position = Vector2(48,0);

onready var _prevPos = global_position;

func _process(_delta):
	SetMovingDirection(global_position - _prevPos);
	_prevPos = global_position;

func Explode():
	$ExplodableModel.Destroy();


func InvulnFlash():
	$ExplodableModel.Hit();
#	var sum := 0.0;
#	var isOn = true;
#
#	while (sum < invulnLength):
#		modulate.a = 0.3 if isOn else 1;
#		isOn = !isOn;
#		yield(get_tree().create_timer(invulnFlashLength),"timeout");
#		sum += invulnFlashLength;
#
#
#	modulate.a = 1.0;
