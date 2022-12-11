extends Sprite

var _rightSide: bool = false;

func SetSideRight(isRight: bool) -> void:
	_rightSide = isRight;

func GetCannonPositions() -> Array:
	if (_rightSide):
		return $RightSide.get_children();
	
	return $LeftSide.get_children();
