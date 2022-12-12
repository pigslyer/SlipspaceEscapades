extends CanvasLayer

const FADE_IN_TIME = 0.8;

onready var timerDisplay: Label = get_node("%TimerDisplay");
onready var healthDisplay: HBoxContainer = get_node("%HealthDisplay");
onready var scoreDisplay: VBoxContainer = get_node("%Score");
onready var tutorial: Control = get_node("%Tutorial");

func Start(timerTime: float):
	StartTimer(timerTime);
	ResetScore();
	OnPlayerHealthChanged(3,0);
	show();
	
	create_tween().tween_property($Root,"modulate:a",1.0, FADE_IN_TIME).set_trans(Tween.TRANS_CUBIC).from(0.0);

func Stop():
	
	var tween := create_tween();
	tween.tween_property($Root, "modulate:a", 0.0, FADE_IN_TIME).set_trans(Tween.TRANS_CUBIC);
	tween.tween_callback(self, "hide");
	

func GetScore() -> int:
	return scoreDisplay.GetScore();

func StartTimer(time: float):
	timerDisplay.StartTimer(time);

func ResetScore():
	scoreDisplay.ResetScore();

func OnPlayerHealthChanged(newHealth: int, newArmor: int):
	healthDisplay.SetHealth(newHealth, newArmor);

func OnScoreGained(amount: int, position: Vector2 = Vector2(-1,-1)):
	if (position == Vector2(-1,-1)):
		position = $Root.get_rect().position + $Root.get_rect().size/2;
	
	scoreDisplay.AddScore(amount, position);
