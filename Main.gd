extends Node
export (PackedScene) var Note

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
	
var r = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()
	for i in range(100):
		var note = Note.instance()
		note.steps = r.randi_range(-12, 12)
		var y: float = i * note.height
		var z: float = i * note.depth	
		note.translate(Vector3(0, -y, z))
		note.rotate_x(deg2rad(12))
		add_child(note)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
