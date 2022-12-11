extends Light2D

var queue: Array = [];
var mean: float = 0.0;

export (int) var flickerAmount = 50;
export (float) var minValue = 0.6;
export (float) var maxValue = 1.2;

func _ready():
	
	for i in flickerAmount:
		queue.append(rand_range(minValue, maxValue));
		mean += queue[-1];

func _process(_delta):
	
	if (queue.size() >= flickerAmount):
		mean -= queue.pop_front();
	
	queue.push_back(rand_range(minValue, maxValue));
	mean += queue[-1];
	
	energy = mean / flickerAmount;
