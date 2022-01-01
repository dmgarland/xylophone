extends Control

export (String, FILE) var main_scene

func _ready():
	$Button.connect("pressed", self, "start")
	$ChangeFile.connect("pressed", self, "_toggle_file_picker")
	$FilePicker.connect("file_selected", self, "_update_file")
	
	_update_file($FilePicker.current_path)
	for note in Sequencer.new($FilePicker.current_path):
		if note:
			print(note.steps)

func _toggle_file_picker():
	$FilePicker.visible = !$FilePicker.visible
	
func _update_file(path):
	$SelectedFile.text = $FilePicker.current_file
	Global.score_path = path

func start():
	Global.polyphony = $Polyphony.value
	Global.load_new_scene(main_scene)
