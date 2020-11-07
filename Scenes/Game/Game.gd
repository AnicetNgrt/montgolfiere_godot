class_name Game
extends Node


var levels_connections = {
	"test0-0a":"res://Scenes/Levels/Test/LevelTest0.tscn"
}


func _ready():
	load_level("res://Scenes/Levels/Test/LevelTest0.tscn", "test0-spawn")


func load_level(level_path:String, entrance_key:String):
	get_tree().paused = true
	if has_node("Level"):
		var prev_level = get_node("Level")
		prev_level.name = "PreviousLevel"
		call_deferred("remove_child", prev_level)
		prev_level.call_deferred("queue_free")

	var new_level = load(level_path).instance()
	call_deferred("add_child", new_level)
	new_level.connect("goto_level", self, "on_level_goto_level")
	new_level.name = "Level"
	new_level.do_self_spawn = false
	yield(new_level, "ready")
	new_level.enter_at(entrance_key)
	get_tree().paused = false
	yield(new_level, "ready_and_spawned")


func on_level_goto_level(entrance_key:String):
	load_level(levels_connections[entrance_key], entrance_key)
