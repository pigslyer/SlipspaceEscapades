extends VBoxContainer

enum{
	BUS_MASTER, 
	BUS_MUSIC, 
	BUS_SFX
};

onready var _masterVolume: HSlider = $Audio/Master/HSlider;
onready var _musicVolume: HSlider = $Audio/Music/HSlider;
onready var _sfxVolume: HSlider = $Audio/SFX/HSlider;

func _on_FancyDisplay_OnOpening():
	_masterVolume.value = VolumeDBToLinear(AudioServer.get_bus_volume_db(BUS_MASTER));
	_musicVolume.value = VolumeDBToLinear(AudioServer.get_bus_volume_db(BUS_MUSIC));
	_sfxVolume.value = VolumeDBToLinear(AudioServer.get_bus_volume_db(BUS_SFX));

func _on_Confirm_pressed():
	Save.SetAudioVolumes(AudioServer.get_bus_volume_db(BUS_MASTER), AudioServer.get_bus_volume_db(BUS_MUSIC), AudioServer.get_bus_volume_db(BUS_SFX));


func _on_Master_volume_changed(value):
	AudioServer.set_bus_volume_db(BUS_MASTER, LinearToVolumeDB(value));


func _on_Music_volume_changed(value):
	AudioServer.set_bus_volume_db(BUS_MUSIC, LinearToVolumeDB(value));


func _on_SFX_volume_changed(value):
	AudioServer.set_bus_volume_db(BUS_SFX, LinearToVolumeDB(value));


const A = (Sounds.SILENT_VOLUME - Sounds.MAX_VOLUME) * log(10) / log(0.01);
const B = Sounds.MAX_VOLUME;

func VolumeDBToLinear(val: float) -> float:
	return exp((val - B) * log(10) / A);

func LinearToVolumeDB(val: float) -> float:
	return A * log(val) / log(10) + B;


