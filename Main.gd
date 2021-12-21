extends Node
export (PackedScene) var Note

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
	
var r = RandomNumberGenerator.new()
var notes_played = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()
	for i in range(50):
		add_note()
		
		
func add_note():
	var note = Note.instance()
	note.steps = r.randi_range(-12, 12)
	var y: float = notes_played * note.height
	var z: float = notes_played * note.depth	
	note.translate(Vector3(0, -y, z))
	note.rotate_x(deg2rad(12))
	note.connect("note_ended", self, "add_note")
	add_child(note)
	notes_played += 1
