extends Node

const BULLET_SCENE = preload("res://Scenes/Bullet.tscn");
const EXPLOSIVE_MISSILE_SCENE = preload("res://Scenes/Powerups/ExplosiveMissile.tscn");
const FRACTAL_MISSILE_SCENE = preload("res://Scenes/Powerups/FractalMissile.tscn");

var explosive_number := 3;
var explosive_strength := 1;

const FRACTAL_NUMBER := 3;
const FRACTAL_TIME := 3.0;
const FRACTAL_STRENGTH := 10.0;
const FRACTAL_LEVELS := 3;
