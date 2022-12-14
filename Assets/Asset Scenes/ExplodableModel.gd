extends Node2D

#signal OnStoppedIFrames;
# warning-ignore:unused_signal
signal OnDestroyed;

export var iframeFlashLength: float = 0.1;
export var iframeLength: float = 0.5;

export var destructionShaderLength = 0.4;
export var destructionParticleStart = 0.2;
export var fadeOutLength = 0.2;
export var fadeOutTime = 0.2;

export (Texture) var model;

onready var onHitMaterial: ShaderMaterial = $OnHit.material as ShaderMaterial;

func _ready():
	SetModel(model);

func SetModel(tex: Texture):
	model = tex;
	$OnHit.texture = model;
	$OnHitPair.texture = model;
	$Explosion.texture = model;

func Hit() -> void:
	var wasFlashed: bool = false;
	
	var length := 0.0;
	while (length < iframeLength):
		onHitMaterial.set_shader_param("flashAmount", 1.0 if wasFlashed else 0.01);
		
		yield(get_tree().create_timer(iframeFlashLength),"timeout");
		length += iframeFlashLength;
		wasFlashed = !wasFlashed;
	
	onHitMaterial.set_shader_param("flashAmount", 1.0);
	
#	emit_signal("OnStoppedIFrames");

func Destroy() -> void:
	$OnHitPair.show();
	
	var tween := create_tween();
	tween.tween_callback($Explosion,"set_emitting", [true]).set_delay(destructionParticleStart);
	tween.parallel().tween_method(self, "_setShaderValue", 0.3, 0.01, destructionShaderLength);
	
	tween.parallel().tween_property($OnHit,"modulate:a", 0.0, fadeOutLength).set_delay(fadeOutTime).set_trans(Tween.TRANS_CUBIC);
	tween.parallel().tween_property($OnHitPair,"modulate:a", 0.0, fadeOutLength).set_delay(fadeOutTime).set_trans(Tween.TRANS_CUBIC);
	
	tween.tween_callback(self,"emit_signal",["OnDestroyed"]).set_delay(fadeOutTime);
	

func _setShaderValue(amount: float):
	onHitMaterial.set_shader_param("flashAmount", amount);
