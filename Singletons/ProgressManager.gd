extends Node

var inventory = []
var spawnpoint:SpawnPoint = preload("res://Scenes/Levels/Earth/sp_earth1_default.tres")
var character_state:CharacterState
var is_initialized = false

signal initialized()

func _ready():
	connect("initialized", self, "on_initialized")
	if not is_savefile_available():
		character_state = CharacterState.new()
	emit_signal("initialized")


func is_savefile_available() -> bool:
	return false


func on_initialized():
	is_initialized = true