class_name Game
extends Control


func _ready():
	load_level("res://Scenes/Level/Levels/Test/LevelTest0.tscn")


func load_level(level_path:String):
	if get_node("Level") != null:
		var prev_level = get_node("Level")
		remove_child(prev_level)
		prev_level.queue_free()
	
	var new_level = load(level_path).instance()
	add_child(new_level)
	new_level.connect("goto_level", self, "on_level_goto_level")
	new_level.name = "Level"


func on_level_goto_level(level_path:String):
	load_level(level_path)
