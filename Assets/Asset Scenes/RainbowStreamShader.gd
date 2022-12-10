extends Sprite

const COLORS = [
	Color.red, Color.orange, Color.yellow, 
	Color.green, Color.blue, Color.violet, 
	Color.green, Color.blue, Color.violet, 
	Color.green, Color.blue, Color.violet,
	Color.white, Color.white, Color.white,
];

var _random := RandomNumberGenerator.new();

var _isOn := false;

export var StreamCount: int = 100;
export var StreamLength: int = 5;
export var BaseHeight: float = 0.06;

onready var _m : ShaderMaterial = material as ShaderMaterial;

func StartStreams() -> void:
	_random.randomize();
	
	var data: Array = [];
	var colors: Array = [];
	
	for i in StreamCount:
		AddPoint(data, colors, float(i) / StreamCount, BaseHeight);
	
	_m.set_shader_param("streamData", ArrayToTexture(data));
	_m.set_shader_param("streamColors", ArrayToTexture(colors));
	_m.set_shader_param("streamCount",data.size());
	_m.set_shader_param("streamLength", StreamLength);
	_m.set_shader_param("t0", Time.get_ticks_msec());
	
	_isOn = false;
	
	show();

func ToggleOn():
	var tween := create_tween();
	tween.tween_method(self,"HiIHaveNoPurposeBeingHere",1.0 if _isOn else 0.0, 0.0 if _isOn else 1.0, 2).set_trans(Tween.TRANS_SINE);
	_isOn = !_isOn;

func HiIHaveNoPurposeBeingHere(value: float):
	_m.set_shader_param("heightMult",value);

func AddPoint(data: Array, colors: Array, height: float, size: float) -> void:
	
	for i in StreamLength:
		colors.append(COLORS[_random.randi() % COLORS.size()]);
	
	data.append(Color(height, size * 1.1, _random.randf_range(2,6) * 0.1, _random.randf() * PI));

func ArrayToTexture(array: Array) -> Texture:
	var image := Image.new();
	image.create(array.size(), 1, false, Image.FORMAT_RGB8);
	
	image.lock();
	
	for i in array.size():
		image.set_pixel(i, 0, array[i]);
	
	image.unlock();
	
	var tex := ImageTexture.new();
	tex.create_from_image(image);
	
	return tex;
