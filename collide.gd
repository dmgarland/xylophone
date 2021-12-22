extends RigidBody

func _ready():
	AudioServer.lock()
	AudioServer.add_bus()
	var bus = AudioServer.bus_count - 1
	AudioServer.set_bus_name(bus, busName())
	AudioServer.set_bus_send(bus, "Master")
	AudioServer.unlock()

func busName():
	return "sphere-%s" % get_instance_id()

func _on_RigidBody_body_entered(body):
	if body is CSGCombiner:
		body.sound(self)

