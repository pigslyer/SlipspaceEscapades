extends Node

const SILENT_VOLUME = -70.0;
const MAX_VOLUME = 10.0;
const FADE_TIME = 0.4;

enum MUSIC{
	NONE,
	GAMEPLAY,
	MENU
};

const TRACKS = {
	MUSIC.GAMEPLAY : preload("res://Assets/Music/40GrittyBitty-4.mp3"),
	MUSIC.MENU : preload("res://Assets/Music/Menu.mp3"),
};

var _music: AudioStreamPlayer = null;

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP;

func StopAllSFX():
	for i in get_children():
		if i != _music:
			i.queue_free();

func PlayMusic(m):
	
	var tween := create_tween().set_parallel();
	
	# crossfade
	if (_music != null):
		tween.tween_property(_music, "volume_db", SILENT_VOLUME, FADE_TIME);
		tween.tween_callback(_music, "queue_free").set_delay(FADE_TIME + 0.1);
	
	
	if (m == MUSIC.NONE):
		_music = null;
	
	else:
		_music = AudioStreamPlayer.new();
		add_child(_music);
		_music.bus = "Music";
		_music.connect("finished", _music, "play");
		
		_music.stream = TRACKS[m];
		_music.volume_db = SILENT_VOLUME;
		_music.play();
		
		tween.tween_property(_music, "volume_db", 0.0, FADE_TIME).from(SILENT_VOLUME);


func PlaySound(stream: AudioStream, pos = null, volume: float = 0.0, pitch: float = 1.0, delay: float = 0.0):
	var player;
	if (pos == null):
		player = AudioStreamPlayer.new();
	else:
		player = AudioStreamPlayer2D.new();
		player.position = pos;
	
	add_child(player);
	player.bus = "Sfx";
	player.connect("finished", player, "queue_free");
	
	player.stream = stream;
	player.volume_db = volume;
	player.pitch_scale = pitch;
	
	if (delay > 0):
		create_tween().tween_callback(player,"play").set_delay(delay);
	else:
		player.play();
	
