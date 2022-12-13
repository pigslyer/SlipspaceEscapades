signal OnPlayerHealthArmorChanged(health, armor)

class_name Player
extends KinematicBody2D

signal OnPlayedDied;

const SHOOT_EFFECT = preload("res://Assets/SFX/GunSound.wav");
const SHOOT_EFFECT_FRACTAL = preload("res://Assets/SFX/FractalMissile.wav");

#CONSTANTS FOR MOVEMENT
const ACCELERATION := 2500;
const FRICTION := 0.2;

#SCENE CONSTANTS
var BULLET_TYPES_SCENES := [
	MissilePowerupVariables.BULLET_SCENE,
	MissilePowerupVariables.EXPLOSIVE_MISSILE_SCENE,
	MissilePowerupVariables.FRACTAL_MISSILE_SCENE,
	preload("res://Scenes/Powerups/BFL.tscn")
];
const SHIELD_SCENE := preload("res://Scenes/Powerups/Shield.tscn");

#POWERUP CONSTANTS
const MAX_HP = 3;
const BFL_TIME = 5;
const BULLET_SPACING = (2 * PI + 0.07) * 0.01;
const SHIELD_POOPS_AMOUNT = 3;
enum BULLET_TYPES {
	NORMAL,
	EXPLOSIVE,
	FRACTAL,
	BFL
};

#POWERUP CHILD NODES
onready var firing_position := $FiringPosition;
onready var shooting_timer := $ShootingTimer;
onready var shield_pooper_timer := $ShieldPooperTimer;
onready var bfl_timer := $BFLTimer;
onready var pussy_timer := $PussyTimer;
onready var bfls := $BFLS;

#MOVEMENT VARIABLES
var velocity := Vector2.ZERO;

#INPUTS
var input := Vector2.ZERO;
var shoot := false;
var can_shoot := true;
var restrict_shooting := false;
var test_powerup := false;

#POWERUP VARIABLES
export(int) var hp = 3;
var armor := 0;
var powerups := {
	"barrage": 0,
	"fire_rate": 0,
	"explosive_rounds": false
};
var remaining_poop_shields = 0;
var next_shot_fractal := false;


var _controlsLocked = false;

func SetControlsLocked(state: bool):
	_controlsLocked = state;


func _ready():
	shooting_timer.connect("timeout", self, "set_can_shoot", [true]);
	bfl_timer.connect("timeout", self, "set_can_shoot", [true]);
	bfl_timer.connect("timeout", self, "clear_bfls");
	bfl_timer.connect("timeout", self, "set_restrict_shoting", [false]);
	shield_pooper_timer.connect("timeout", self, "poop_shields", [], CONNECT_DEFERRED);

func _physics_process(delta):
	check_input();
	
	velocity += input * ACCELERATION * delta;
	velocity *= 1 - FRICTION;
	
	$BasicShip.SetMovingDirection(input);
	
	velocity = move_and_slide(velocity, Vector2.UP);
	
	if(can_shoot && shoot):
		var bullet_type;
		if(next_shot_fractal):
			bullet_type = BULLET_TYPES.FRACTAL;
			next_shot_fractal = false;
		else:
			bullet_type = BULLET_TYPES.NORMAL if !powerups["explosive_rounds"] else BULLET_TYPES.EXPLOSIVE;
		fire_bullet(bullet_type);
		can_shoot = false;
		shooting_timer.start(1.0/(2*powerups["fire_rate"]+3));
	
	if (!_controlsLocked):
		look_at(get_global_mouse_position());

func fire_bullet(bullet_type) -> void:
	var sound = SHOOT_EFFECT_FRACTAL if bullet_type == BULLET_TYPES.FRACTAL else SHOOT_EFFECT;
	
	var bullet_type_scene = BULLET_TYPES_SCENES[bullet_type];
	var parent = get_parent();
	
	var new_bullet = bullet_type_scene.instance();
	new_bullet.global_position = firing_position.global_position;
	new_bullet.collision_layer = 64;
	new_bullet.rotation = rotation;
	parent.add_child(new_bullet);
	
	var pitchMult = 1 + powerups["fire_rate"] * 0.1;
	
	Sounds.PlaySound(sound, null, 0.0, pitchMult * rand_range(0.9,1.1));
	
	if (powerups["barrage"] > 0):
		Sounds.PlaySound(sound, null, 0.0, pitchMult * rand_range(1.2,1.4),0.1);
		Sounds.PlaySound(sound, null, 0.0, pitchMult * rand_range(1.2,1.4),0.2);
	
	
	for i in powerups["barrage"]:
		var angle = (i + 1) * BULLET_SPACING;
		
		var new_bullet1 = bullet_type_scene.instance();
		new_bullet1.rotation = rotation + angle;
		new_bullet1.global_position = firing_position.global_position;
		new_bullet1.collision_layer = 64;
		parent.add_child(new_bullet1);
		
		var new_bullet2 = bullet_type_scene.instance();
		new_bullet2.rotation = rotation - angle;
		new_bullet2.global_position = firing_position.global_position;
		new_bullet2.collision_layer = 64;
		parent.add_child(new_bullet2);
	
	

func add_powerup(powerup) -> void:
	match(powerup):
		Global.POWERUPS.HEALTH:
			hp += 1;
			emit_signal("OnPlayerHealthArmorChanged", hp, armor);
		Global.POWERUPS.ARMOR:
			armor += 1;
			emit_signal("OnPlayerHealthArmorChanged", hp, armor);
		Global.POWERUPS.BFL:
			fire_BFL();
		Global.POWERUPS.BARRAGE:
			powerups["barrage"] += 1;
		Global.POWERUPS.EXPLOSIVE:
			powerups["explosive_rounds"] = true;
			MissilePowerupVariables.explosive_number += 2;
			MissilePowerupVariables.explosive_strength += 1;
		Global.POWERUPS.FIRERATE:
			powerups["firerate"] += 1;
		Global.POWERUPS.FRACTAL:
			next_shot_fractal = true;
		Global.POWERUPS.SHIELD:
			shield_pooper_timer.stop();
			remaining_poop_shields += SHIELD_POOPS_AMOUNT;
			call_deferred("poop_shields");

func check_input() -> void:
	if (_controlsLocked):
		input = Vector2.ZERO;
		shoot = false;
		test_powerup = false;
	
	else:
		input = Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		);
		
		shoot = Input.is_action_pressed("shoot");
		test_powerup = Input.is_action_just_pressed("test_powerup");

func fire_BFL() -> void:
	restrict_shooting = true;
	can_shoot = false;
	
	var bfl_scene = BULLET_TYPES_SCENES[BULLET_TYPES.BFL];
	
	var pitchMult = powerups["fire_rate"];
	
	var new_bfl = bfl_scene.instance();
	new_bfl.position = firing_position.position;
	bfls.add_child(new_bfl);
	new_bfl.SetSoundSettings(1 + pitchMult * 0.1, 0);
	
	for i in powerups["barrage"]:
		var angle = (i + 1) * BULLET_SPACING;
		
		var new_bfl1 = bfl_scene.instance();
		new_bfl1.rotation = angle;
		new_bfl1.position = firing_position.position;
		bfls.add_child(new_bfl1);
		new_bfl1.SetSoundSettings(1 + (i + pitchMult) * 0.1, i * 0.1);
		
		var new_bfl2 = bfl_scene.instance();
		new_bfl2.rotation = -angle;
		new_bfl2.position = firing_position.position;
		bfls.add_child(new_bfl2);
		new_bfl2.SetSoundSettings(1 + (i + pitchMult) * 0.1, i * 0.1);
		
	bfl_timer.start(BFL_TIME);

func clear_bfls() -> void:
	for child in bfls.get_children():
		child.Disable();

func poop_shields() -> void:
	if(remaining_poop_shields > 0):
		var new_shield = SHIELD_SCENE.instance();
		new_shield.global_position = global_position;
		new_shield.collision_mask = 136;
		get_parent().add_child(new_shield);
		
		remaining_poop_shields = remaining_poop_shields - 1;
		shield_pooper_timer.start();

func set_restrict_shoting(can : bool) -> void:
	restrict_shooting = can;

func set_can_shoot(can : bool) -> void:
	if(!restrict_shooting && can_shoot == false):
		can_shoot = can;

func body_entered(entity):
	if(!entity.is_in_group("Powerups") && pussy_timer.is_stopped()):
		hp -= 1; #Pussy move as well
		pussy_timer.start();
		print(hp);
