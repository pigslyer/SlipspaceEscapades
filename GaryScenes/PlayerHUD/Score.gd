extends VBoxContainer

const FLY_TIME = 0.9;

var _score: int = 0;
var _scoreDisplay: int = 0;

func _ready():
	Save.connect("OnHighscoredChanged",self,"OnHighscoreUpdated");
	OnHighscoreUpdated(Save.GetHighscore());

func AddScore(amount: int, from: Vector2):
	var label := Label.new();
	Save.add_child(label);
	label.align = Label.ALIGN_CENTER;
	label.valign = Label.VALIGN_CENTER;
	
	label.text = str("+",amount);
	label.rect_global_position = from;
	label.rect_scale = Vector2.ONE * 1.4;
	
	var tween := create_tween();
	tween.tween_property(label, "rect_global_position",$ScoreElementTarget.global_position, FLY_TIME);
	tween.parallel().tween_property(label, "modulate:a", 0.0, FLY_TIME/2).set_trans(Tween.TRANS_CUBIC).set_delay(FLY_TIME/2);
	tween.parallel().tween_property(label, "rect_scale", Vector2.ZERO, FLY_TIME/2).set_trans(Tween.TRANS_CUBIC).set_delay(FLY_TIME/2);
	tween.tween_callback(self, "UpdateScore", [amount]);
	tween.tween_callback(label, "queue_free");
	_score += amount;

func UpdateScore(amount: int):
	_scoreDisplay += amount;
	_updateScoreText();

func ResetScore():
	_score = 0;
	_scoreDisplay = 0;
	_updateScoreText();

func _updateScoreText():
	$Score.text = "Score: %d" % _scoreDisplay;

func OnHighscoreUpdated(to: int):
	$Highscore.text = "Highscore: %d" % to;

func GetScore() -> int:
	return _score;
