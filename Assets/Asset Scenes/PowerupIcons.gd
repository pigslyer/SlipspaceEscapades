extends Node2D

signal OnAnimationFinished;

const FADE_IN_TIME = 0.5;
const FADE_OUT_TIME = 0.5;

const PW = Global.POWERUPS;

const TEXTURES = {
	PW.ARMOR : preload("res://Assets/Sprites/Icons/Armor.png"),
	PW.BARRAGE : preload("res://Assets/Sprites/Icons/Barrage.png"),
	PW.BFL : preload("res://Assets/Sprites/Icons/BFL.png"),
	PW.EXPLOSIVE : preload("res://Assets/Sprites/Icons/ExplosiveShot.png"),
	PW.FIRERATE : preload("res://Assets/Sprites/Icons/FireRate.png"),
	PW.FRACTAL : preload("res://Assets/Sprites/Icons/FractalMissile.png"),
	PW.HEALTH : preload("res://Assets/Sprites/Icons/HealthPickup.png"),
	PW.SHIELD : preload("res://Assets/Sprites/Icons/Shield.png")
}

export (Global.POWERUPS, FLAGS) var isFlashing;
export (Global.POWERUPS, FLAGS) var isRed;

onready var _m: ShaderMaterial = $Powerup.material as ShaderMaterial;

func ShowIcon(icon):
	$Powerup.texture = TEXTURES[icon];
	_m.set_shader_param("isFlashing", (isFlashing & icon) != 0);
	_m.set_shader_param("isRed", (isRed & icon) != 0);
	_m.set_shader_param("t0", Time.get_ticks_msec());

func Appear():
	create_tween().tween_property(self, "scale", Vector2.ONE, FADE_IN_TIME).from(Vector2.ZERO);

func Disappear():
	var tween := create_tween();
	tween.tween_property(self, "scale", Vector2.ZERO, FADE_OUT_TIME).from(Vector2.ONE);
	tween.tween_callback(self, "emit_signal", ["OnAnimationFinished"]);
