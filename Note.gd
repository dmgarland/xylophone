extends CSGCombiner

const ref_freq = 440.0
const A = pow(2.0, 1.0 / 12.0)
export var sample_hz = 22050.0
export var steps = 0
export var polyphony = 1
var pulse_hz
var notes: Array
var bodies = {}
var started = false

signal note_ended

func _fill_buffer(note):	
	var increment = pulse_hz / sample_hz
	var playback = note['player'].get_stream_playback()	
	var to_fill = playback.get_frames_available()
	
	while to_fill > 0:		
		playback.push_frame(note['amp'] * sin(note['phase'] * TAU))
		note['phase'] = fmod(note['phase'] + increment, 1.0)
		to_fill -= 1
		
func _ready():	
	pulse_hz = ref_freq * pow(A, steps)
	$note.width = 24 - steps
	AudioServer.lock()
	
	for i in range(polyphony):
		var player = AudioStreamPlayer3D.new()
		AudioServer.add_bus()
		var bus = AudioServer.bus_count - 1
		var name = "Bus %s" % bus
		AudioServer.set_bus_name(bus, name)
		AudioServer.set_bus_send(bus, "Master")
		player.stream = AudioStreamGenerator.new()
		player.stream.mix_rate = sample_hz
		player.bus = name	
		var note = {
			'player': player,
			'amp': Vector2.ONE,
			'phase': 0.0,
			'ended': false
		}
		_fill_buffer(note)
		notes.append(note)
		add_child(player)
		
	AudioServer.unlock()
	
func _process(delta):
	var ended = true
		
	for note in notes:
		if note['player'].playing:
			_fill_buffer(note)
			
			if note['amp'].x < 0.01:
				note['player'].stop()
				note['ended'] = true
			else:			
				note['amp'] = note['amp'].linear_interpolate(Vector2.ZERO, delta)
			
		ended = ended && note['ended']
			
	if bodies.size() > 0 && ended:
		print('ending note')
		emit_signal('note_ended')
		queue_free()

func sound(body):	
	if !bodies.has(body):			
		var note = notes[bodies.size()]		
		bodies[body] = note		
		if !note['player'].playing:
			#print(note)
			note['player'].play()
			started = true
