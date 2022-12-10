extends Sprite

var random := RandomNumberGenerator.new();

#var colorOptions = [Color.red, Color.yellow, Color.green, Color.purple, Color.crimson, Color.blue, Color.cyan, Color.lime, Color.white, Color.white];
var colorOptions = [Color.cyan, Color.blue, Color.aqua];

onready var _m : ShaderMaterial = material as ShaderMaterial;

func StartStreams() -> void:
	var data: Array = [];
	var colors: Array = [];
	
#	AddPoint(data, colors, Color.darkslateblue, 0.0, 0.4);
#	AddPoint(data, colors, Color.red, 0.6, 0.2);
#	AddPoint(data, colors, Color.blue, 0.4, 0.3);
#	AddPoint(data, colors, Color.yellow, 0.8, 0.2);
#	AddPoint(data, colors, Color.darkblue, 0.9, 0.4);
#	AddPoint(data, colors, Color.purple, 1.0, 0.4);
	
	for i in range(10):
		AddPoint(data, colors, colorOptions[random.randi() % colorOptions.size()], random.randf(), random.randf() * 0.5);
	
	_m.set_shader_param("streamData", ArrayToTexture(data));
	_m.set_shader_param("streamColors", ArrayToTexture(colors));
	_m.set_shader_param("streamCount",data.size());
	_m.set_shader_param("t0", Time.get_ticks_msec());
	
	show();

func AddPoint(data: Array, colors: Array, color: Color, height: float, size: float) -> void:
	colors.append(color);
	data.append(Color(height, size, random.randf() * PI));

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
