extends Sprite

signal OnTrailFinished;

export (float) var Speed = 1.0;
export (float) var Stay = 1.0;
export (float) var CatchUp = 1.0;

func Start():
	material.set_shader_param("CatchUpTime", 0.0);
	var tween := create_tween();
	tween.tween_method(self, "_stupidMethod", 0.0, 1.0, Speed, [false]).set_trans(Tween.TRANS_CUBIC);
	tween.tween_method(self, "_stupidMethod", 0.0, 1.0, CatchUp, [true]).set_trans(Tween.TRANS_CUBIC).set_delay(Stay);
	
	yield(tween, "finished");
	material.set_shader_param("CurrentTime", 1.0);
	material.set_shader_param("CatchUpTime", 1.0);
	
	emit_signal("OnTrailFinished");

func _stupidMethod(val: float, catchUp: bool):
	material.set_shader_param("CatchUpTime" if catchUp else "CurrentTime", val);
