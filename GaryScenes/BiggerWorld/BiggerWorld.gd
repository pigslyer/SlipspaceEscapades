extends Control

const ENTERING_SLIPSPACE := preload("res://Assets/SFX/EnteringSlipspace.wav");
const PLAYER_DIED := preload("res://Assets/SFX/PlayerDeath.wav");
const GAME_OVER_VOICE := preload("res://Assets/SFX/GameOverVoice.wav");
const WON_SOUND = preload("res://Assets/Music/ChirpyW.wav");

const GAME_OVER_FADE_TIME = 1.4;

export (float) var gameplayTime = 60;

export (String, MULTILINE) var wonText;
export (String, MULTILINE) var lostText;

func _ready():
	$Player.SetControlsLocked(true);
	
	$CanvasLayer/BlackScreen.modulate.a = 1.0;
	create_tween().tween_property($CanvasLayer/BlackScreen, "modulate:a",0.0, GAME_OVER_FADE_TIME);

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
	
	# uncomment for guaranteed quick game over
	#yield(get_tree().create_timer(2.0),"timeout");
	#_on_Player_OnPlayedDied();


# win
func _on_World_OnTimerEnded():
	if (_hasLost):
		return;
	
	Save.SetHighscore($HUD.GetScore());
	
	$Player.SetControlsLocked(true);
	$SlipspaceBackground.SetSlipspace(false);
	$HUD.Stop();
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	Sounds.PlaySound(WON_SOUND);
	
	var tween = create_tween().set_loops();
	tween.tween_callback(Sounds,"PlaySound",[WON_SOUND]).set_delay(20);
	
	yield(get_tree().create_timer(2),"timeout");
	
	_displayEndingText(wonText);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	tween.kill();
	$CanvasLayer/MainMenu.ChangeMenuVisibility(true);

var _hasLost = false;

# lose
func _on_Player_OnPlayedDied():
	_hasLost = true;
	Save.SetHighscore($HUD.GetScore());
	
	$HUD.Stop();
	Sounds.PlaySound(PLAYER_DIED);
	$Player.SetControlsLocked(true);
	
	var tween := create_tween().set_parallel();
	
	tween.tween_property($SlipspaceBackground,"modulate:a",0.0, GAME_OVER_FADE_TIME).set_delay(0.5);
	tween.tween_property($CanvasLayer/BlackScreen, "modulate:a", 1.0, GAME_OVER_FADE_TIME).set_delay(0.5);
	
	yield(tween, "finished");
	
	Sounds.PlaySound(GAME_OVER_VOICE);
	
	yield(get_tree().create_timer(2.2), "timeout");
	
	_displayEndingText(lostText);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	# faster than moving the player around and shit
	get_tree().reload_current_scene();

func _displayEndingText(end: String):
	$CanvasLayer/EndingText.Open("%s\n\nScore: %d\nHighscore: %d" % [end, $HUD.GetScore(), Save.GetHighscore()]);

