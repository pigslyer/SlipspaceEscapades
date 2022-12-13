extends Control

const ENTERING_SLIPSPACE := preload("res://Assets/SFX/EnteringSlipspace.wav");

export (float) var gameplayTime = 60;

export (String, MULTILINE) var wonText;
export (String, MULTILINE) var lostText;

func _ready():
	$Player.SetControlsLocked(true);

func _on_MainMenu_OnStartGame():
	$CanvasLayer/MainMenu.ChangeMenuVisibility(false);
	Sounds.PlaySound(ENTERING_SLIPSPACE);
	
	# eyeballed
	yield(get_tree().create_timer(0.5),"timeout");
	$SlipspaceBackground.SetSlipspace(true);
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	$Player.SetControlsLocked(false);
	$HUD.Start(gameplayTime);
	$World.StartGameplay(gameplayTime);

# win
func _on_World_OnTimerEnded():
	Save.SetHighscore($HUD.GetScore());
	
	$Player.SetControlsLocked(true);
	$SlipspaceBackground.SetSlipspace(false);
	$HUD.Stop();
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	_displayEndingText(wonText);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	
	
	$CanvasLayer/MainMenu.ChangeMenuVisibility(true);

# lose
func _on_Player_OnPlayedDied():
	Save.SetHighscore($HUD.GetScore());
	
	# play an explosion or somesuch
	

func _displayEndingText(end: String):
	$CanvasLayer/EndingText.Open("%s\n\nScore: %d\nHighscore: %d" % [end, $HUD.GetScore(), Save.GetHighscore()]);

