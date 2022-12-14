extends Node2D

const TYPE_SCENES = [
	preload("res://Scenes/Asteroids/SmallAsteroid.tscn"),
	preload("res://Scenes/Asteroids/BigAsteroid.tscn")
]

onready var top_spawn = {
	"top_left" : $TopSpawn/TopLeft.global_position,
	"bottom_right" : $TopSpawn/BottomRight.global_position
};
onready var bottom_spawn = {
	"top_left" : $BottomSpawn/TopLeft.global_position,
	"bottom_right" : $BottomSpawn/BottomRight.global_position
}

var gameplay_stopped := true;

func spawn_asteroid(type : int) -> void:
	if(!gameplay_stopped):
		var new_asteroid = TYPE_SCENES[type].instance();
		var spawned_top = randf() < 0.5;
		var spawn_pos;
		
		if(spawned_top):
			spawn_pos = Vector2(
				rand_range(top_spawn["top_left"].x, top_spawn["bottom_right"].x),
				rand_range(top_spawn["top_left"].y, top_spawn["bottom_right"].y)
			)
			new_asteroid.dir = Vector2.RIGHT.rotated(PI * 0.5);
		else:
			spawn_pos = Vector2(
				rand_range(bottom_spawn["top_left"].x, bottom_spawn["bottom_right"].x),
				rand_range(bottom_spawn["top_left"].y, bottom_spawn["bottom_right"].y)
			)
			new_asteroid.dir = Vector2.RIGHT.rotated(-PI * 0.5);
		
		new_asteroid.dir = new_asteroid.dir.rotated(rand_range(-0.5, 0.5));
		new_asteroid.global_position = spawn_pos;
		add_child(new_asteroid);
