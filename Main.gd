extends Node
export (PackedScene) var Note
export (PackedScene) var Ball
	
var r = RandomNumberGenerator.new()
var notes_played = 0;
var camera: Camera
var spheres = []
var z = 0.0

const polyphony = 2;

func _ready():
	r.randomize()
	for _i in range(25):
		add_note()
		
	for i in range(polyphony):
		var sphere = Ball.instance()	
		sphere.translate(Vector3(-3 + i * 2, 10 + i * 2, 3))
		add_child(sphere)
		spheres.append(sphere)
		
	camera = Camera.new()
	add_child(camera)
	
func add_note():
	var note = Note.instance()
	note.polyphony = polyphony
	note.steps = r.randi_range(-12, 12)
	note.beats = r.randi_range(2, 12)
	var y: float = (notes_played * 2)
	
	note.connect("note_ended", self, "add_note")
	var resized = note.resize_and_translate(y, z)
	add_child(resized)	
	z+=resized.width()
	notes_played += 1
	
	
func _process(_delta):
	var target = Vector3.ZERO
	var min_z = INF
	var max_z = 0
	for sphere in spheres:
		var p = sphere.global_transform.origin
		
		target += p
		min_z = min(p.z, min_z)
		max_z = max(p.z, max_z)
		
			
	target = target / spheres.size()
	var diff = max_z - min_z
	var zoom = Vector3(diff * 0.7, 10, diff * 0.7) + Vector3.ONE
	camera.look_at_from_position((target + zoom), target, Vector3(0, 1, 0))	
