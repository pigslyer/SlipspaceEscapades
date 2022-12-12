extends Node

signal OnHighscoredChanged(to);

var _highScore: int = 0;

func _ready():
	var file := _getFile();
	
	if (file != null):
		_highScore = file.get_value("NonSettings","highscore",0);

func GetHighscore() -> int:
	return _highScore;

func SetHighscore(score: int):
	if (score > _highScore):
		_highScore = score;
		
		var file := _getFile();
		file.set_value("NonSettings","highscore",score);
		_saveFile(file);
		emit_signal("OnHighscoredChanged",_highScore);

const filePath: String = "user://save.ini";

func _getFile() -> ConfigFile:
	var ret := ConfigFile.new();
	ret.load(filePath);
	return ret;
	
	var dir := Directory.new();
	
	if (dir.file_exists(filePath)):
		var conf := ConfigFile.new();
		conf.load(filePath);
		return conf;
	
	return null;

func _saveFile(file: ConfigFile) -> void:
	file.save(filePath);
