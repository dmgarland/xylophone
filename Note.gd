extends CSGCombiner

const ref_freq = 440.0
const A = pow(2.0, 1.0 / 12.0)
export var sample_hz = 22050.0
export var steps = 0
var pulse_hz
var phase = 0.0
var playback: AudioStreamPlayback = null
var amp = Vector2.ONE

signal note_ended

func _fill_buffer():	
	var increment = pulse_hz / sample_hz
	var to_fill = playback.get_frames_available()
	
	while to_fill > 0:		
		playback.push_frame(amp * sin(phase * TAU))
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1
		
func _ready():	
	pulse_hz = ref_freq * pow(A, steps)
	$note.width = 24 - steps
	$player.stream.mix_rate = sample_hz
	playback = $player.get_stream_playback()
	_fill_buffer()
	
	
func _process(delta):
	_fill_buffer()
	
	if $player.playing:
		if amp.x < 0.01:
			$player.stop()			
			emit_signal('note_ended')
			queue_free()
			
		else:			
			amp = amp.linear_interpolate(Vector2.ZERO, delta)

func sound():
	if !$player.playing:
		$player.play()
