extends Control

export (String, FILE) var main_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", self, "start")

func start():	
	Global.polyphony = $Polyphony.value
	Global.load_new_scene(main_scene)
