extends Node

var current_level

func _ready():
	load_current_level()

func load_current_level():
	if not ProgressManager.is_initialized:
		yield(ProgressManager, "initialized")
	LevelLoader.load_level(ProgressManager.spawnpoint)
