extends Node

# Declare member variables here. Examples:
var polyphony = 2;
var score_path: String

func _ready():
	pass

func load_new_scene(new_scene_path):
	get_tree().change_scene(new_scene_path)
