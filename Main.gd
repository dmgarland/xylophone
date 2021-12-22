extends Node
export (PackedScene) var Note
export (PackedScene) var Ball
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
	
var r = RandomNumberGenerator.new()
var notes_played = 0;
var camera: Camera
var target: Spatial

const polyphony = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()
	for i in range(25):
		add_note()
		
	for i in range(polyphony):
		var ball = Ball.instance()
		target = ball
		ball.translate(Vector3(-3 + i * 2, 10 + i, 0))
		add_child(ball)
		
	
	camera = Camera.new()
	add_child(camera)
	
		
func add_note():
	var note = Note.instance()
	note.polyphony = polyphony
	note.steps = r.randi_range(-12, 12)
	var y: float = (notes_played * 2)
	var z: float = notes_played * 6
	note.translate(Vector3(0, -y, z))
	note.rotate_x(deg2rad(12))
	note.connect("note_ended", self, "add_note")
	add_child(note)
	notes_played += 1
	
func _process(delta):
	camera.look_at_from_position(target.translation + Vector3(10, 15, 10), target.translation, Vector3(0, 1, 0))	
