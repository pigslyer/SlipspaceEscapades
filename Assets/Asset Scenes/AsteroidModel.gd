extends Node2D

signal OnStoppedIFrames;
# warning-ignore:unused_signal
signal OnDestroyed;
# warning-ignore:unused_signal
signal OnShouldSpawn;

export var iframeFlashLength: float = 0.1;
export var iframeLength: float = 0.5;

export var destructionShaderLength = 0.4;
export var destructionParticleStart = 0.2;
export var fadeOutLength = 0.2;
export var fadeOutTime = 0.2;


onready var onHitMaterial: ShaderMaterial = $OnHit.material as ShaderMaterial;

func AsteroidHit() -> void:
	var wasFlashed: bool = false;
	
	var length := 0.0;
	while (length < iframeLength):
		onHitMaterial.set_shader_param("flashAmount", 1.0 if wasFlashed else 0.01);
		
		yield(get_tree().create_timer(iframeFlashLength),"timeout");
		length += iframeFlashLength;
		wasFlashed = !wasFlashed;
	
	onHitMaterial.set_shader_param("flashAmount", 1.0);
	
	emit_signal("OnStoppedIFrames");

func AsteroidDestroyed() -> void:
	$OnHitPair.show();
	
	var tween := create_tween();
	tween.tween_callback($Explosion,"set_emitting", [true]).set_delay(destructionParticleStart);
	tween.parallel().tween_method(self, "_setShaderValue", 0.3, 0.01, destructionShaderLength);
	
	tween.parallel().tween_property($OnHit,"modulate:a", 0.0, fadeOutLength).set_delay(fadeOutTime).set_trans(Tween.TRANS_CUBIC);
	tween.parallel().tween_property($OnHitPair,"modulate:a", 0.0, fadeOutLength).set_delay(fadeOutTime).set_trans(Tween.TRANS_CUBIC);
	
	tween.tween_callback(self,"emit_signal",["OnDestroyed"]);
	
	# for debugging
	yield(get_tree().create_timer(2),"timeout");
	$OnHit.modulate.a = 1;
	$OnHitPair.modulate.a = 1;
	onHitMaterial.set_shader_param("flashAmount", 1);
	$OnHitPair.hide();
	

func AsteroidDestroyedDropsPowerup() -> void:
	$OnHitPair.show();
	
	var tween := create_tween();
	tween.tween_callback($ExplosionImplosion,"set_emitting", [true]).set_delay(destructionParticleStart);
	tween.parallel().tween_method(self, "_setShaderValue", 0.3, 0.01, destructionShaderLength);
	
	tween.parallel().tween_property($OnHit,"modulate:a", 0.0, fadeOutLength).set_delay(fadeOutTime).set_trans(Tween.TRANS_CUBIC);
	tween.parallel().tween_property($OnHitPair,"modulate:a", 0.0, fadeOutLength).set_delay(fadeOutTime).set_trans(Tween.TRANS_CUBIC);
	
	tween.tween_callback(self,"emit_signal",["OnShouldSpawn"]);
	
	# for debugging
	yield(get_tree().create_timer(2),"timeout");
	$OnHit.modulate.a = 1;
	$OnHitPair.modulate.a = 1;
	onHitMaterial.set_shader_param("flashAmount", 1);
	$OnHitPair.hide();

func _setShaderValue(amount: float):
	onHitMaterial.set_shader_param("flashAmount", amount);
