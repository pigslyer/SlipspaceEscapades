extends HBoxContainer

var _health: int = 3;
var _armor: int = 0;

func SetHealth(health: int, armor: int):
	
	if (_health != health):
		_health = health;
		
		for i in health:
			get_child(i).modulate = Color.white;
		
		for i in range(health, 3):
			get_child(i).modulate = Color.black;
	
	if (_armor != armor):
		_armor = armor;
		
		$Armor.visible = armor > 0;
		$ArmorCount.visible = armor > 1;
		$ArmorCount.text = "%dx" % armor;
