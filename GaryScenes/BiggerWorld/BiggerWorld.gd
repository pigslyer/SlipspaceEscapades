extends Control

const ENTERING_SLIPSPACE := preload("res://Assets/SFX/EnteringSlipspace.wav");
const GAME_OVER_VOICE := preload("res://Assets/SFX/GameOverVoice.wav");
const WON_SOUND = preload("res://Assets/Music/ChirpyW.wav");

const GAME_OVER_FADE_TIME = 1.4;

export (float) var GameplayTime = 60.0;

export (String, MULTILINE) var WonText;
export (String, MULTILINE) var NewGamePlusText;
export (String, MULTILINE) var LostText;

func _ready():
	BeginPlayerPassiveAnimation();
	Sounds.PlayMusic(Sounds.MUSIC.MENU);
	$Player.SetControlsLocked(true);
	
	$CanvasLayer/BlackScreen.modulate.a = 1.0;
	create_tween().tween_property($CanvasLayer/BlackScreen, "modulate:a",0.0, GAME_OVER_FADE_TIME);

var _started: bool = false;

func _on_MainMenu_OnStartGame():
	if (_started):
		return;
	
	_started = true;
	EndPlayerPassiveAnimation();
	# add the entering slipspace thing
	Sounds.PlayMusic(Sounds.MUSIC.GAMEPLAY);
	$CanvasLayer/MainMenu.ChangeMenuVisibility(false);
	$Player.UpdateHealthArmorHUD();
	
	yield(get_tree().create_timer(5.5),"timeout");
	Sounds.PlaySound(ENTERING_SLIPSPACE);
	
	create_tween().tween_callback($Player,"ThrustersOn", [false]).set_delay(0.2);
	# eyeballed
	yield(get_tree().create_timer(0.5),"timeout");
	
	$SlipspaceBackground.SetSlipspace(true);
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	$CanvasLayer/Paused.SetPauseMenuOn(true);
	$Player.SetControlsLocked(false);
	$HUD.Start(GameplayTime);
	$World.StartGameplay(GameplayTime);
	_started = false;
	
	# uncomment for guaranteed quick game over
#	yield(get_tree().create_timer(2.0),"timeout");
#	_on_Player_OnPlayedDied();


# win
func _on_World_OnTimerEnded():
	if (_hasLost):
		return;
	
	Global.AddScore(1000);
	var score = $HUD.GetScore();
	var record = Save.GetHighscore();
	
	Sounds.PlayMusic(Sounds.MUSIC.NONE);
	Save.SetHighscore(score);
	
	get_tree().call_group("SHIELD","DestroyShield");
	$Player.StopPoopingShields();
	$Player.SetControlsLocked(true);
	$Player.RotateRight(true);
	$SlipspaceBackground.SetSlipspace(false);
	$HUD.Stop();
	$World.StopGameplay();
	$CanvasLayer/MainMenu.NewGamePlusIncrement();
	
	create_tween().tween_callback($Player,"ThrustersOn", [true]).set_delay(0.5);
	
	yield($SlipspaceBackground,"FinishedTransition");
	
	get_tree().call_group("GARBAGE","queue_free");
	Sounds.PlaySound(WON_SOUND);
	
	yield(get_tree().create_timer(2),"timeout");
	
	_displayEndingText(WonText, score, record);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	$CanvasLayer/EndingText.Open(NewGamePlusText);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	$CanvasLayer/Paused.SetPauseMenuOn(true);
	$Player.RotateRight(false);
	
	$CanvasLayer/MainMenu.ChangeMenuVisibility(true);
	Sounds.PlayMusic(Sounds.MUSIC.MENU);
	BeginPlayerPassiveAnimation();

var _hasLost = false;

# lose
func _on_Player_OnPlayedDied():
	Sounds.PlayMusic(Sounds.MUSIC.NONE);
	_hasLost = true;
	var score = $HUD.GetScore();
	var record = Save.GetHighscore();
	Save.SetHighscore(score);
	
	$CanvasLayer/Paused.SetPauseMenuOn(false);
	get_tree().call_group("SHIELD","DestroyShield");
	$World.StopGameplay();
	$HUD.StopPlayerDied();
	$Player.SetControlsLocked(true);
	
	var tween := create_tween().set_parallel();
	
	tween.tween_property($SlipspaceBackground,"modulate:a",0.0, GAME_OVER_FADE_TIME).set_delay(0.5);
	tween.tween_property($CanvasLayer/BlackScreen, "modulate:a", 1.0, GAME_OVER_FADE_TIME).set_delay(0.5);
	
	yield(tween, "finished");
	
	get_tree().paused = true;
	Sounds.PlaySound(GAME_OVER_VOICE);
	
	yield(get_tree().create_timer(2.2), "timeout");
	
	_displayEndingText(LostText % int(GameplayTime - $HUD.GetTime()), score, record);
	
	yield($CanvasLayer/EndingText, "OnHidden");
	
	Sounds.StopAllSFX();
	
	yield(get_tree(), "idle_frame");
	# faster than moving the player around and shit
	get_tree().paused = false;
	get_tree().reload_current_scene();

func _displayEndingText(end: String, score: int, record: int):
	$CanvasLayer/EndingText.Open("%s\n\nScore: %d\n%sRecord: %d" % [end, score, "Previous " if score > record else "", record]);


# it ain't perfect, but it's what we got (is it enough for you?)
var _playerTween: SceneTreeTween;

const PASSIVE_DELTA = 8;
const PASSIVE_TIME = 3;

func BeginPlayerPassiveAnimation():
	_playerTween = create_tween().set_loops();
	
	_playerTween.tween_property($Player,"position", $Player.position + Vector2(0, -PASSIVE_DELTA), PASSIVE_TIME).set_delay(0.5)#.set_trans(Tween.TRANS_CUBIC);
	_playerTween.tween_property($Player,"position", $Player.position + Vector2(0, PASSIVE_DELTA), PASSIVE_TIME * 2).set_delay(0.5)#.set_trans(Tween.TRANS_CUBIC);
	

func EndPlayerPassiveAnimation():
	_playerTween.kill();

