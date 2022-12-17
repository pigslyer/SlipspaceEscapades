extends Label

var _isGaming: bool = false;
var _isDisplaying: bool = false;
var _displayingState: bool = false;

func SetPauseMenuOn(state: bool):
	_isGaming = state;

func TogglePauseScreenDisplay():
	PauseScreenDisplay(!_isDisplaying);

func PauseScreenDisplay(state: bool):
	_isDisplaying = state;
	_displayingState = true;
	visible = state;
	get_tree().paused = state;
	VisualServer.set_shader_time_scale(0 if state else 1);
	#Sounds.PauseMusic(state);
	
	if state:
		$OnOffTimer.start();
	else:
		$OnOffTimer.stop();


func OnTimerTimeout():
	_displayingState = !_displayingState;
	visible = _displayingState;

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		if _isGaming:
			TogglePauseScreenDisplay();
		else:
			get_tree().quit();
