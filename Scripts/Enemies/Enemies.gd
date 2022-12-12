class_name Enemies
extends Node2D

enum SHIP_TYPES {
	BASIC,
	BASIC_VARIANT,
	PLASMA
};

const SHIP_TYPES_SCENES = [
	preload("res://Scenes/Enemies/BasicShip.tscn"),
	preload("res://Scenes/Enemies/BasicVariantShip.tscn"),
	preload("res://Scenes/Enemies/PlasmaShip.tscn")
];

const SHIP_GROUPS = [
	"BasicShips",
	"BasicVariantShips",
	"PlasmaShips"
];

const MAX_ATTACKER_NUMBERS = [
	2,
	1,
	3
];

export(NodePath) var player_path;

var attacker_numbers = [
	0,
	0,
	0
];

var player;

func _ready():
	player = get_tree().get_nodes_in_group("PLAYER")[0];
	#spawn_ships();

func spawn_ships():
	for i in range(5):
		spawn_ship(SHIP_TYPES.PLASMA);

func get_spawn_pos() -> Vector2:
	var viewport_size = get_viewport_rect().size;
	var spawn_pos := Vector2(
		rand_range(viewport_size.x * 0.8, viewport_size.x * 0.9),
		rand_range(viewport_size.y * 0.1, viewport_size.y * 0.9)
	);
	return spawn_pos;

func spawn_ship(ship_type) -> void:
	var new_ship = SHIP_TYPES_SCENES[ship_type].instance();
	new_ship.global_position = get_spawn_pos();
	new_ship.player = player;
	new_ship.connect("attacking", self, "add_attacker", [ship_type]);
	new_ship.connect("dying", self, "remove_attacker", [ship_type]);
	add_child(new_ship);

func add_attacker(type : int) -> void:
	attacker_numbers[type] += 1;

func remove_attacker(type : int) -> void:
	attacker_numbers[type] -= 1;

func _physics_process(delta):
	for type in SHIP_TYPES.values():
		for child in get_children():
			if !child.is_queued_for_deletion() && child.is_in_group(SHIP_GROUPS[type]) && !child.is_attacking:
				if attacker_numbers[type] < MAX_ATTACKER_NUMBERS[type]:
					child.is_attacking = true;
					attacker_numbers[type] += 1;
