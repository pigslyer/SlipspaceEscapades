extends Node2D

var _isSlipspace: bool = false;

func _ready():
	StartShaders();

func StartShaders() -> void:
	$StarryNight.GenerateStars();
	$RainbowStreamShader.StartStreams();

func _input(event):
	if event.is_action_pressed("ui_accept"):
		SetSlipspace(!_isSlipspace);


func SetSlipspace(state: bool) -> void:
	
	if state != _isSlipspace:
		_isSlipspace = state;
		
		$RainbowStreamShader.SetOn(!state);
		
		if state:
			$StarryNight.RemoveStars();
		else:
			# result of eyeballing, starts them just as the "exiting" effect is strongest
			yield(get_tree().create_timer(2.0), "timeout");
			$StarryNight.GenerateStars();
