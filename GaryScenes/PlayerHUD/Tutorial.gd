extends Control

const FADE_OUT_TIME = 1;
const FADE_OUT_DELAY = 1.2;

var _detectedMovement: bool = true;
var _detectedShooting: bool = true;

func StartTutorial():
	_detectedMovement = false;
	_detectedShooting = false;
	$AnimationPlayer.play("FadeIn");

func _input(ev: InputEvent):
	
	if (!_detectedShooting && ev.is_action_pressed("shoot", true)):
		_detectedShooting = true;
		_fadeOut($Shooting);
	
	if (!_detectedMovement && (ev.is_action_pressed("move_down", true) || ev.is_action_pressed("move_left", true) || ev.is_action_pressed("move_right", true) || ev.is_action_pressed("move_up", true))):
		_detectedMovement = true;
		_fadeOut($Movement);

func _fadeOut(node: Control):
	
	if ($AnimationPlayer.is_playing()):
		var tween := create_tween();
		tween.tween_property($Movement, "modulate:a", 0.0, FADE_OUT_TIME).set_trans(Tween.TRANS_CUBIC);
		tween.tween_property($Shooting, "modulate:a", 0.0, FADE_OUT_TIME).set_trans(Tween.TRANS_CUBIC);
		$AnimationPlayer.stop();
	
	else:
		var tween := create_tween();
		tween.tween_property(node, "modulate:a", 0.0, FADE_OUT_TIME).set_trans(Tween.TRANS_CUBIC).set_delay(FADE_OUT_DELAY);
	


