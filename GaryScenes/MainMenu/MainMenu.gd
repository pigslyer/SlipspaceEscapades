extends Control

signal OnStartGame;

const FADE_TIME = 0.9;

var _visible: bool = true;

func _ready():
	$HighScoreDisplay.text = "Highscore: %d" % Save.GetHighscore();

func ChangeMenuVisibility(new_vis: bool):
	if (new_vis != _visible):
		_visible = new_vis;
		
		if (_visible):
			show();
		
		var tween := create_tween();
		tween.tween_property(self,"modulate:a",1.0 if new_vis else 0.0, FADE_TIME);
		
		if (!_visible):
			tween.tween_callback(self,"hide");


func _on_Begin_pressed():
	emit_signal("OnStartGame");

func _on_Quit_pressed():
	get_tree().quit();


func _on_Story_pressed():
	$TextDisplay.Open("Some story");
