extends Node

signal OnHighscoredChanged(to);

var _highScore: int = 0;

func _ready():
	var file := _getFile();
	
	if (file != null):
		_highScore = file.get_value("NonSettings","highscore",0);
		AudioServer.set_bus_volume_db(0, file.get_value("Settings", "volumeMaster", -3.4));
		AudioServer.set_bus_volume_db(1, file.get_value("Settings", "volumeMusic", -3.4));
		AudioServer.set_bus_volume_db(2, file.get_value("Settings", "volumeSFX", -13.4));

func GetHighscore() -> int:
	return _highScore;

func SetHighscore(score: int):
	if (score > _highScore):
		_highScore = score;
		
		var file := _getFile();
		file.set_value("NonSettings","highscore",score);
		_saveFile(file);
		emit_signal("OnHighscoredChanged",_highScore);


func SetAudioVolumes(vMaster: float, vMusic: float, vSFX: float):
	var file := _getFile();
	file.set_value("Settings", "volumeMaster", vMaster);
	file.set_value("Settings", "volumeMusic", vMusic);
	file.set_value("Settings", "volumeSFX", vSFX);
	_saveFile(file);


const filePath: String = "user://save.ini";

func _getFile() -> ConfigFile:
	var ret := ConfigFile.new();
	ret.load(filePath);
	return ret;

func _saveFile(file: ConfigFile) -> void:
	file.save(filePath);
