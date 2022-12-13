extends Sprite

var _rightSide: bool = false;

func SetSideRight(isRight: bool) -> void:
	_rightSide = isRight;

func get_left_children() -> Array:
	return $LeftSide.get_children();

func get_right_children() -> Array:
	return $RightSide.get_children();
