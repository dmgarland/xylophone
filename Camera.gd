extends Camera

var target: RigidBody

func _ready():
	target = get_parent().find_node("RigidBody")

func _process(delta):	
	look_at_from_position(target.translation + Vector3(10, 15, 10), target.translation, Vector3(0, 1, 0))
