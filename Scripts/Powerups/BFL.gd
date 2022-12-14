class_name BFL
extends Area2D

const FADE_OUT_TIME = 2;

var strength = 99999999;

func SetSoundSettings(pitch: float, delay: float):
	$BflLoop.pitch_scale = pitch;
	
	if (delay == 0):
		$BflLoop.play();
	else:
		create_tween().tween_callback($BflLoop,"play").set_delay(delay);

func Disable():
	set_deferred("collision_layer",0);
	set_deferred("collision_mask",0);
	
	var tween := create_tween();
	tween.tween_property(self, "scale:y", 0.0, FADE_OUT_TIME).set_trans(Tween.TRANS_CUBIC);
	tween.parallel().tween_property($BflLoop,"volume_db",Sounds.SILENT_VOLUME, FADE_OUT_TIME).set_trans(Tween.TRANS_CUBIC);
	tween.tween_callback(self, "queue_free");
