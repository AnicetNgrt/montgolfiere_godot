extends Node

var artifacts = []
var spawnpoint = preload("res://Content/Regions/earth/_levels/earth/_resources/sp_earth1_default.tres")
var platformer_controller_state:PlatformerControllerState
var is_initialized = false

signal initialized()

func _ready():
	connect("initialized", self, "on_initialized")
	if not is_savefile_available():
		platformer_controller_state = PlatformerControllerState.new()
	emit_signal("initialized")


func is_savefile_available() -> bool:
	return false


func on_initialized():
	is_initialized = true


func on_npc_triggered(npc:NPC):
	pass
