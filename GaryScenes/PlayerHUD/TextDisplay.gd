extends Control

signal OnHidden;

const OPEN_TIME = 0.8;

export (Vector2) var hiddenVector = Vector2.LEFT;

func _ready():
	rect_scale = hiddenVector;

func Open(text: String):
	$Panel/Panel/RichTextLabel.text = text;
	
	var tween := create_tween();
	tween.tween_property(self, "rect_scale",Vector2.ONE, OPEN_TIME).set_trans(Tween.TRANS_CUBIC);

func _on_Button_pressed():
	var tween := create_tween();
	tween.tween_property(self, "rect_scale", hiddenVector, OPEN_TIME).set_trans(Tween.TRANS_CUBIC);
	tween.tween_callback(self, "emit_signal",["OnHidden"]);
