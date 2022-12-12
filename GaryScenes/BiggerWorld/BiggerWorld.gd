extends Control

export (float) var gameplayTime = 60;

export (String, MULTILINE) var wonText;

func _on_MainMenu_OnStartGame():
	$CanvasLayer/MainMenu.ChangeMenuVisibility(false);
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
	
	$CanvasLayer/EndingText.Open(wonText);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	$CanvasLayer/MainMenu.ChangeMenuVisibility(true);

# lose
func _on_Player_OnPlayedDied():
	Save.SetHighscore($HUD.GetScore());
	
	# play an explosion or somesuch
	



