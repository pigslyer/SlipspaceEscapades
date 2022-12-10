extends Node2D

func _ready():
	StartShaders();

func StartShaders() -> void:
#	$StreamShader.StartStreams();
	$RainbowStreamShader.StartStreams();

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$RainbowStreamShader.ToggleOn();
