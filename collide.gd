extends RigidBody

var bomb: Timer

func _ready():
	AudioServer.lock()
	AudioServer.add_bus()
	var bus = AudioServer.bus_count - 1
	AudioServer.set_bus_name(bus, busName())
	AudioServer.set_bus_send(bus, "Master")
	AudioServer.unlock()
	
	bomb = Timer.new()
	add_child(bomb)
	bomb.autostart = true	
	bomb.one_shot = true
	bomb.connect("timeout", self, "queue_free")
	

func busName():
	return "sphere-%s" % get_instance_id()

func _on_RigidBody_body_entered(body):
	bomb.start(3.0)	
	if body.has_method("sound"):
		body.sound(self)

