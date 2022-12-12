extends Node2D

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
