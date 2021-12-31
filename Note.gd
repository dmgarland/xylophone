extends CSGCombiner

const ref_freq = 440.0
const A = pow(2.0, 1.0 / 12.0)
export var sample_hz = 22050.0
export var steps = 0
export var beats = 1
var pulse_hz
var notes: Array
var bodies = {}

signal note_started
#signal note_ended

func _fill_buffer(note):	
	var increment = pulse_hz / sample_hz
	var playback = note['player'].get_stream_playback()	
	var to_fill = playback.get_frames_available()
	
	while to_fill > 0:		
		playback.push_frame(note['amp'] * sin(note['phase'] * TAU))
		note['phase'] = fmod(note['phase'] + increment, 1.0)
		to_fill -= 1
		
func width():
	return $note.depth + $slopes/slope_left/box.depth
	
func resize_and_translate(y, z):
	$note.width = (24 - steps) * 1.5
	$note.depth = beats
	$note.translate(Vector3(0, -y, z + $note.depth / 2.0))
	$slopes.translate(Vector3(0, -y, z + ($note.depth + $slopes/slope_left/box.depth / 2)))
	rotate_x(deg2rad(12))
	
	return self
		
func _ready():	
	pulse_hz = ref_freq * pow(A, steps)
	
	for _i in range(Global.polyphony):
		var player = AudioStreamPlayer3D.new()		
		player.stream = AudioStreamGenerator.new()
		player.stream.mix_rate = sample_hz
		
		var note = {
			'player': player,
			'amp': Vector2.ONE,
			'phase': 0.0,
			'ended': false
		}
		_fill_buffer(note)
		notes.append(note)
		add_child(player)
		
func reap():
	var playing = false
	for note in notes:
		playing = playing || note['player'].playing
	if !playing:
		queue_free()
	
func _process(delta):
	for note in notes:
		if note['player'].playing:
			if note['amp'].x < 0.01:
				note['player'].stop()
				note['ended'] = true
			else:
				_fill_buffer(note)
				note['amp'] = note['amp'].linear_interpolate(Vector2.ZERO, delta * 1.5)

func sound(body):
	if !bodies.has(body):
		var note = notes[bodies.size()]		
		bodies[body] = note		
		if !note['player'].playing:
			#print(note)
			note['player'].bus = body.busName()
			note['player'].play()
			emit_signal("note_started")
