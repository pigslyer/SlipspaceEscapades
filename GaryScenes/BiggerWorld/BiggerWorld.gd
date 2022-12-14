extends Control

const ENTERING_SLIPSPACE := preload("res://Assets/SFX/EnteringSlipspace.wav");
const GAME_OVER_VOICE := preload("res://Assets/SFX/GameOverVoice.wav");
const WON_SOUND = preload("res://Assets/Music/ChirpyW.wav");

const GAME_OVER_FADE_TIME = 1.4;

export (float) var gameplayTime = 60;

export (String, MULTILINE) var wonText;
export (String, MULTILINE) var lostText;

func _ready():
	BeginPlayerPassiveAnimation();
	Sounds.PlayMusic(Sounds.MUSIC.MENU);
	$Player.SetControlsLocked(true);
	
	$CanvasLayer/BlackScreen.modulate.a = 1.0;
	create_tween().tween_property($CanvasLayer/BlackScreen, "modulate:a",0.0, GAME_OVER_FADE_TIME);

func _on_MainMenu_OnStartGame():
	EndPlayerPassiveAnimation();
	# add the entering slipspace thing
	Sounds.PlayMusic(Sounds.MUSIC.GAMEPLAY);
	$CanvasLayer/MainMenu.ChangeMenuVisibility(false);
	
	yield(get_tree().create_timer(5.5),"timeout");
	Sounds.PlaySound(ENTERING_SLIPSPACE);
	
	# eyeballed
	yield(get_tree().create_timer(0.5),"timeout");
	$SlipspaceBackground.SetSlipspace(true);
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	$Player.SetControlsLocked(false);
	$HUD.Start(gameplayTime);
	$World.StartGameplay(gameplayTime);
	
	# uncomment for guaranteed quick game over
#	yield(get_tree().create_timer(2.0),"timeout");
#	_on_Player_OnPlayedDied();


# win
func _on_World_OnTimerEnded():
	if (_hasLost):
		return;
	
	Global.AddScore(1000);
	Sounds.PlayMusic(Sounds.MUSIC.NONE);
	Save.SetHighscore($HUD.GetScore());
	
	get_tree().call_group("SHIELD","DestroyShield");
	$Player.SetControlsLocked(true);
	$Player.RotateRight(true);
	$SlipspaceBackground.SetSlipspace(false);
	$HUD.Stop();
	$World.StopGameplay();
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	get_tree().call_group("GARBAGE","queue_free");
	Sounds.PlaySound(WON_SOUND);
	
	var tween = create_tween().set_loops();
	tween.tween_callback(Sounds,"PlaySound",[WON_SOUND]).set_delay(20);
	
	yield(get_tree().create_timer(2),"timeout");
	
	_displayEndingText(wonText);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	$Player.RotateRight(false);
	tween.kill();
	$CanvasLayer/MainMenu.ChangeMenuVisibility(true);
	Sounds.PlayMusic(Sounds.MUSIC.MENU);
	BeginPlayerPassiveAnimation();

var _hasLost = false;

# lose
func _on_Player_OnPlayedDied():
	Sounds.PlayMusic(Sounds.MUSIC.NONE);
	_hasLost = true;
	Save.SetHighscore($HUD.GetScore());
	
	get_tree().call_group("SHIELD","DestroyShield");
	$World.StopGameplay();
	$HUD.Stop();
	$Player.SetControlsLocked(true);
	
	var tween := create_tween().set_parallel();
	
	tween.tween_property($SlipspaceBackground,"modulate:a",0.0, GAME_OVER_FADE_TIME).set_delay(0.5);
	tween.tween_property($CanvasLayer/BlackScreen, "modulate:a", 1.0, GAME_OVER_FADE_TIME).set_delay(0.5);
	
	yield(tween, "finished");
	
	Sounds.PlaySound(GAME_OVER_VOICE);
	
	yield(get_tree().create_timer(2.2), "timeout");
	
	_displayEndingText(lostText % int(gameplayTime - $HUD.GetTime()));
	
	yield($CanvasLayer/EndingText, "OnHidden");
	# faster than moving the player around and shit
	get_tree().reload_current_scene();

func _displayEndingText(end: String):
	$CanvasLayer/EndingText.Open("%s\n\nScore: %d\nHighscore: %d" % [end, $HUD.GetScore(), Save.GetHighscore()]);


# it ain't perfect, but it's what we got (is it enough for you?)
var tween: SceneTreeTween;

const PASSIVE_DELTA = 8;
const PASSIVE_TIME = 3;

func BeginPlayerPassiveAnimation():
	tween = create_tween().set_loops();
	
	tween.tween_property($Player,"position", $Player.position + Vector2(0, -PASSIVE_DELTA), PASSIVE_TIME).set_delay(0.5)#.set_trans(Tween.TRANS_CUBIC);
	tween.tween_property($Player,"position", $Player.position + Vector2(0, PASSIVE_DELTA), PASSIVE_TIME * 2).set_delay(0.5)#.set_trans(Tween.TRANS_CUBIC);
	

func EndPlayerPassiveAnimation():
	tween.kill();
