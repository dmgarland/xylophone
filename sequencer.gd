class_name Sequencer

var score_csv: File
var current
var line_reg_exp: RegEx
var line_count = 1

func _init(score_path: String):
	score_csv = File.new()
	score_csv.open(score_path, File.READ)
	line_reg_exp = RegEx.new()
	line_reg_exp.compile("(?<note>[A-G]+#?)(?<octave>\\d),(?<duration>\\d+),?(?<angle>\\d+)?")
	
func _iter_init(_arg):	
	current = _parse_line()
	return current != null
	
func _iter_next(_arg):	
	current = _parse_line()
	line_count += 1
	return current != null
	
func _iter_get(_arg):	
	return current
	
func _parse_line() -> Note:
	var line = score_csv.get_line()
	if line:
		var parsed = line_reg_exp.search(line)
		
		if parsed:
			return Note.new(
				parsed.get_string("note"), 
				parsed.get_string("octave") as int, 
				parsed.get_string("duration") as int,
				parsed.get_string("angle") as int if parsed.get_string("angle") else 12
				)
		else:
			print("Line %d is invalid: %s" % [line_count, line])
			return null
	else:
		return null

class Note:
	# steps relative to A3
	var steps: int
	var duration: int
	var angle: int
	
	const STEPS = ['A','A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']
	
	func _init(note: String, octave: int, duration: int, angle: int):
		self.steps = STEPS.find(note) + (octave - 3) * 12
		self.duration = duration
		self.angle = angle
