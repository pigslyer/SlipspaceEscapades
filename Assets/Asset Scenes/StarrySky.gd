extends MultiMeshInstance2D

var _rng := RandomNumberGenerator.new();

export (int) var instanceCount = 1800;

func GenerateStars():
	multimesh.mesh = $Pixel.mesh;
	multimesh.visible_instance_count = instanceCount;
	var screenSize = get_viewport_rect().size;
	
	for i in instanceCount:
		var v = Vector2(_rng.randfn(0.5, 0.5) * screenSize.x / global_scale.x, _rng.randfn(0.5, 0.5) * screenSize.y / global_scale.y);
		var t = Transform2D(0.0, v);
		multimesh.set_instance_transform_2d(i, t);

func HideStars():
	multimesh.visible_instance_count = 0;
