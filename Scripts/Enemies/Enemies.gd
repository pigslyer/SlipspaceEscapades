class_name Enemies
extends Node2D

const BARRAGE_TIME := 40;
const BASIC_VARIANT_TIME := 50;
const PLASMA_TIME := 35;
const SHIELD_TIME := 30;
const BIG_BOY_TIME := 20;
const BIG_BOY_FRACTAL_TIME := 10;

const SHIP_TYPES_SCENES = [
	preload("res://Scenes/Enemies/BasicShip.tscn"),
	preload("res://Scenes/Enemies/BasicVariantShip.tscn"),
	preload("res://Scenes/Enemies/PlasmaShip.tscn"),
	preload("res://Scenes/Enemies/BigBoy.tscn"),
	preload("res://Scenes/Enemies/ShieldPooperShip.tscn")
];

const SHIP_GROUPS = [
	"BasicShips",
	"BasicVariantShips",
	"PlasmaShips",
];

const MAX_ATTACKER_NUMBERS = [
	2,
	1,
	3,
];

onready var basic_spawn_timer := $BasicSpawnTimer;
onready var basic_variant_spawn_timer := $BasicVariantSpawnTimer;
onready var plasma_spawn_timer := $PlasmaSpawnTimer;
onready var shield_spawn_timer := $ShieldSpawnTimer;
onready var enemy_spawn_top_left = $EnemySpawnArea/TopLeft.global_position;
onready var enemy_spawn_bottom_right = $EnemySpawnArea/BotomRight.global_position;

var attacker_numbers = [
	0,
	0,
	0
];

var player;
var big_boy = null;
var basic_ships_barrage := false;
var countdown_timer;
var gameplay_stopped := true;
var big_boy_spawned := false;

func _ready():
	player = get_tree().get_nodes_in_group("PLAYER")[0];

func get_spawn_pos() -> Vector2:
	var spawn_pos := Vector2(
		rand_range(enemy_spawn_top_left.x, enemy_spawn_bottom_right.x),
		rand_range(enemy_spawn_top_left.y, enemy_spawn_bottom_right.y)
	);
	return spawn_pos;

func spawn_ship(ship_type) -> void:
	var new_ship = SHIP_TYPES_SCENES[ship_type].instance();
	new_ship.global_position = get_spawn_pos();
	if(ship_type != Global.SHIP_TYPES.SHIELD_POOPER):
		if(ship_type != Global.SHIP_TYPES.PLASMA):
			new_ship.player = player;
		new_ship.connect("attacking", self, "add_attacker", [ship_type]);
		new_ship.connect("dying", self, "remove_attacker", [ship_type]);
	if(ship_type == Global.SHIP_TYPES.BASIC or ship_type == Global.SHIP_TYPES.BASIC_VARIANT):
		new_ship.barrage = countdown_timer.time_left < BARRAGE_TIME;
	add_child(new_ship);

func add_attacker(type : int) -> void:
	attacker_numbers[type] += 1;

func remove_attacker(type : int) -> void:
	attacker_numbers[type] -= 1;

func stop_gameplay() -> void:
	gameplay_stopped = true;
	big_boy = null;
	big_boy_spawned = false;
	for child in get_children():
		if(child.is_in_group("Entities")):
			child.gameplay_stopped = true;

func _physics_process(delta):
	if(!gameplay_stopped && !countdown_timer.is_stopped()):
		var time_left = countdown_timer.time_left;
		
		if(basic_spawn_timer.is_stopped()):
			spawn_ship(Global.SHIP_TYPES.BASIC);
			basic_spawn_timer.start();
		if(time_left < BASIC_VARIANT_TIME and basic_variant_spawn_timer.is_stopped()):
			spawn_ship(Global.SHIP_TYPES.BASIC_VARIANT);
			basic_variant_spawn_timer.start();
		if(time_left < PLASMA_TIME and plasma_spawn_timer.is_stopped()):
			spawn_ship(Global.SHIP_TYPES.PLASMA);
			plasma_spawn_timer.start();
		if(time_left < SHIELD_TIME and shield_spawn_timer.is_stopped()):
			spawn_ship(Global.SHIP_TYPES.SHIELD_POOPER);
			shield_spawn_timer.start();
		if(time_left < BIG_BOY_TIME and big_boy == null and !big_boy_spawned):
			big_boy = SHIP_TYPES_SCENES[Global.SHIP_TYPES.BIG_BOY].instance();
			big_boy.global_position = get_spawn_pos();
			big_boy_spawned = true;
			add_child(big_boy);
		if(time_left < BIG_BOY_FRACTAL_TIME and big_boy != null):
			if is_instance_valid(big_boy):
				big_boy.can_shoot_fractals = true;
		
		for type in Global.SHIP_TYPES.values():
			if(type != Global.SHIP_TYPES.SHIELD_POOPER and type != Global.SHIP_TYPES.BIG_BOY):
				for child in get_children():
					if !child.is_queued_for_deletion() && child.is_in_group(SHIP_GROUPS[type]) && !child.is_attacking:
						if attacker_numbers[type] < MAX_ATTACKER_NUMBERS[type]:
							child.is_attacking = true;
							attacker_numbers[type] += 1;
