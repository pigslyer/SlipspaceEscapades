extends Label

var _curTime: float;

func _ready():
	set_process(false);

func StartTimer(totalTime: float):
	set_process(true);
	_curTime = totalTime;
	_updateText();

func _process(delta):
	_curTime = max(0, _curTime - delta);
	_updateText();

func _updateText():
	text = "Time: %6.3f" % _curTime;
