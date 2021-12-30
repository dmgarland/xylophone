extends Node
export (PackedScene) var Note
export (PackedScene) var Ball
export (String, FILE) var menu_scene
	
var r = RandomNumberGenerator.new()
var notes_played = 0;
var camera: Camera
var spheres = []
var z = 0.0

func _ready():
	r.randomize()
	for _i in range(25):
		add_note()
		
	$start_slope/shear.height = Global.polyphony
	$start_slope.translate(Vector3(0, 0, -(Global.polyphony / 2)))
	
	for i in range(Global.polyphony):
		var sphere = Ball.instance()		
		sphere.translate(Vector3(0, 10, -i))
		add_child(sphere)
		spheres.append(sphere)
		
	camera = Camera.new()
	add_child(camera)
	
func add_note():
	var note = Note.instance()
	note.steps = r.randi_range(-12, 12)
	note.beats = r.randi_range(2, 12)
	var y: float = (notes_played * 1.4)
	
	note.connect("note_started", self, "add_note")
	var resized = note.resize_and_translate(y, z)
	add_child(resized)	
	z+=resized.width()
	notes_played += 1
	
	
func _process(_delta):
	var target = Vector3.ZERO
	var min_z = INF
	var max_z = 0

	for sphere in spheres:
		if sphere == null:
			spheres.erase(sphere)
			continue
			
		var p = sphere.global_transform.origin
		target += p
		min_z = min(p.z, min_z)
		max_z = max(p.z, max_z)
		
	if spheres.size() == 0:
		Global.load_new_scene(menu_scene)

	target = target / spheres.size()
	var diff = max_z - min_z
	var zoom = Vector3(diff * 0.5, 10, diff * 0.5) + Vector3.ONE
	camera.look_at_from_position((target + zoom), target, Vector3(0, 1, 0))	
