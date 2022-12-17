extends Label

const LEAVING_SLIPSPACE_SOUND := preload("res://Assets/SFX/LeavingSlipspace.wav");
const ENGINE_WARMUP = 4.3;

var _curTime: float;
var _hasPlayedSound: bool = false;

func _ready():
	set_process(false);

func StopTimer():
	set_process(false);

func StartTimer(totalTime: float):
	set_process(true);
	_curTime = totalTime;
	_updateText();
	_hasPlayedSound = false;

func _process(delta):
	_curTime = max(0, _curTime - delta);
	_updateText();
	
	if (_curTime < ENGINE_WARMUP && !_hasPlayedSound):
		_hasPlayedSound = true;
		$LeavingSlipspace.play();

func _updateText():
	text = "Time: %6.3f" % _curTime;

func GetTime():
	return _curTime;

func SetTime(time):
	_curTime = time;
	_updateText();
