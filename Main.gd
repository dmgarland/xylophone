extends Node
export (PackedScene) var Note
export (PackedScene) var Ball
export (String, FILE) var menu_scene
	
var r = RandomNumberGenerator.new()
var notes_played = 0;
var camera: Camera
var spheres = []
var z = 0.0
var reaper: Timer

func _ready():
	r.randomize()
	for _i in range(4):
		add_note()
		
	$start_slope/shear.height = Global.polyphony
	$start_slope.translate(Vector3(0, 0, -(Global.polyphony / 2)))
	
	for i in range(Global.polyphony):
		var sphere = Ball.instance()		
		sphere.translate(Vector3(0, 10, -i))
		add_child(sphere)
		spheres.append(sphere)
		
	camera = Camera.new()
	camera.translate(Vector3(10, 10, 10))
	add_child(camera)
	
	reaper = Timer.new()
	reaper.autostart = true
	reaper.wait_time = 1.0
	reaper.connect("timeout", self, "reap_notes")
	add_child(reaper)
	
func add_note():
	var note = Note.instance()
	note.steps = r.randi_range(-12, 12)
	note.beats = r.randi_range(2, 12)
	var y: float = (notes_played * 1.4)
	
	note.connect("note_started", self, "add_note")
	note.resize_and_translate(y, z)
	$notes.add_child(note)	
	z+=note.width()
	notes_played += 1

func get_sphere_bounds(): 
	var bounds = spheres[0].get_child(0).get_child(0).get_transformed_aabb()
	for i in range(1, spheres.size()):
		var sphere = spheres[i]		
		bounds = bounds.merge(sphere.get_child(0).get_child(0).get_transformed_aabb())
	return bounds
	
func reap_notes():
	var bounds = get_sphere_bounds()
	for note in $notes.get_children():
		if note.get_transformed_aabb().abs().end.z < bounds.abs().position.z - 1.0:			
			note.reap()
	
func find_z_bounds():
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
		
	return [min_z, max_z, target]
	
func _process(delta):
	
	var bounds = find_z_bounds()
	var min_z = bounds[0];
	var max_z = bounds[1];
	var target = bounds[2];
	#var bounds = get_sphere_bounds()
	#var min_z = bounds.position.z
	#var max_z = bounds.end.z
	#var target = bounds.end / spheres.size() as float
			
	if spheres.size() == 0:
		Global.load_new_scene(menu_scene)

	target = target / spheres.size()
	#var diff = bounds.size.z
	var diff = max_z - min_z
	var zoom = Vector3(diff * 0.5, 10, diff * 0.5) + Vector3.ONE
	#camera.look_at_from_position((target + zoom), target, Vector3(0, 1, 0))
	#camera.transform.interpolate_with(target, cam_speed * _delta)
	#camera.look_at(target, Vector3(0, 1, 0))
	#camera.translation = camera.translation.linear_interpolate(target, t)
	var T = camera.global_transform.looking_at(target, Vector3(0, 1, 0))
	
	camera.global_transform.origin.x = lerp(camera.global_transform.origin.x, (target + zoom).x, delta)
	camera.global_transform.origin.y = lerp(camera.global_transform.origin.y, (target + zoom).y, delta)
	camera.global_transform.origin.z = lerp(camera.global_transform.origin.z, (target + zoom).z, delta)
	camera.global_transform.basis.x = lerp(camera.global_transform.basis.x, T.basis.x, delta)
	camera.global_transform.basis.y = lerp(camera.global_transform.basis.y, T.basis.y, delta)
	camera.global_transform.basis.z = lerp(camera.global_transform.basis.z, T.basis.z, delta)
	
