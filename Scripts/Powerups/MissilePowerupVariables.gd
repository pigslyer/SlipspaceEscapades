extends Node

const BULLET_SCENE = preload("res://Scenes/Bullet.tscn");
const EXPLOSIVE_MISSILE_SCENE = preload("res://Scenes/Powerups/ExplosiveMissile.tscn");
const FRACTAL_MISSILE_SCENE = preload("res://Scenes/Powerups/FractalMissile.tscn");

var explosive_number := 5;
var explosive_time := 0.5;
var explosive_strength := 4;

const FRACTAL_NUMBER := 3;
const FRACTAL_TIME := 3.0;
const FRACTAL_STRENGTH := 10.0;
const FRACTAL_LEVELS := 3;
