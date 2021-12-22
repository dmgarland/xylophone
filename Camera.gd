extends Camera


var target: Spatial

func _ready():
	target = get_parent().get_children()[1]
	print(target)


