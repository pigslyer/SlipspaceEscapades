extends Sprite

#var _random := RandomNumberGenerator.new();

export var StarCount: int = 20;

onready var _m: ShaderMaterial = material as ShaderMaterial;

func GenerateStars() -> void:
	pass
	#_random.randomize();
	
	#var data = [];
	
#	for i in StarCount:
#		AddStar(data, Vector2(_random.randfn(0.6, 0.2),_random.randfn(0.6, 0.2)),_random.randf_range(0.005, 0.01));
	
	
#	for i in StarCount:
#		VisualServer.canvas_item_add_circle(RID(Object(self)), Vector2(data[i].r,data[i].g),0.1,Color.white);
#	_m.set_shader_param("starData", ArrayToTexture(data));
#	_m.set_shader_param("starCount", data.size());
	

func RemoveStars():
	pass
#	_m.set_shader_param("starCount", 0);

#func AddStar(array: Array, pos: Vector2, size: float) -> void:
#	array.append(Color(pos.x,pos.y,size * 0.4, log(_random.randfn(4.5,4.5))/log(10)));

#func ArrayToTexture(array: Array) -> Texture:
#	var image := Image.new();
#	image.create(array.size(), 1, false, Image.FORMAT_RGB8);
#
#	image.lock();
#
#	for i in array.size():
#		image.set_pixel(i, 0, array[i]);
#
#	image.unlock();
#
#	var tex := ImageTexture.new();
#	tex.create_from_image(image);
#
#	return tex;
