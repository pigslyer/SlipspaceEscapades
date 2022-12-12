class_name Enemies
extends Node2D

enum SHIP_TYPES {
	BASIC
};

const SHIP_TYPES_SCENES = [
	preload("res://Scenes/Enemies/BasicShip.tscn")
];

const MAX_ATTACKER_NUMBERS = [
	2
];

export(NodePath) var player_path;

var attacker_numbers = [
	0
];

var player;

func _ready():
	player = get_node(player_path);
	spawn_ships();

func spawn_ships():
	for i in range(5):
		spawn_simple_ship();

func spawn_simple_ship() -> void:
	var new_simple_ship = SHIP_TYPES_SCENES[SHIP_TYPES.BASIC].instance();
	var viewport_size = get_viewport_rect().size;
	new_simple_ship.global_position = Vector2(
		rand_range(viewport_size.x * 0.8, viewport_size.x * 0.9),
		rand_range(viewport_size.y * 0.1, viewport_size.y * 0.9)
	);
	new_simple_ship.player = player;
	new_simple_ship.connect("dying", self, "remove_attacker", [SHIP_TYPES.BASIC]);
	add_child(new_simple_ship);

func remove_attacker(type : int) -> void:
	attacker_numbers[type] -= 1;

func _physics_process(delta):
	for child in get_children():
		if !child.is_queued_for_deletion() && child is BasicShip && !child.is_attacking:
			if attacker_numbers[SHIP_TYPES.BASIC] < MAX_ATTACKER_NUMBERS[SHIP_TYPES.BASIC]:
				child.is_attacking = true;
				print(child.name, " ", child.is_attacking);
				attacker_numbers[SHIP_TYPES.BASIC] += 1;
