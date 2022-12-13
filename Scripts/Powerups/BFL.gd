class_name BFL
extends Area2D

const FADE_OUT_TIME = 2;

func Disable():
	set_deferred("collision_layer",0);
	set_deferred("collision_mask",0);
	
	var tween := create_tween();
	tween.tween_property(self, "scale:y", 0.0, FADE_OUT_TIME).set_trans(Tween.TRANS_CUBIC);
	tween.tween_callback(self, "queue_free");
