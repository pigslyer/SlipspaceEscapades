extends Node2D

# turns the trail on or off based on whether we're moving. overrides manual trail control but doesn't impact visibility
export (bool) var autoPowerOnOff = true;

export (bool) var autoStart = true;
export (float) var size = 1.0;

# if alpha is zero keeps at default random
export (Color) var trailColor = Color.transparent;

onready var prevPos: Vector2 = global_position;

func _ready():
	set_process(autoPowerOnOff);
	
	$Particles2D.process_material.scale = size;
	
	if (trailColor.a > 0):
		$Particles2D.process_material.color = trailColor;
		$Particles2D.process_material.color_initial_ramp = null;
	
	EnableTrail(autoStart);

func EnableTrail(state: bool):
	visible = state;
	$Particles2D.emitting = state;

func _process(delta):
	$Particles2D.emitting = global_position != prevPos;
	prevPos = global_position;
