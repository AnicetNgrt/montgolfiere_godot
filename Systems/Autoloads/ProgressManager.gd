extends Node


var progress_db
var platformer_controller_state:PlatformerControllerState
var is_initialized = false

signal initialized()

func _ready():
	connect("initialized", self, "on_initialized")
	platformer_controller_state = PlatformerControllerState.new()
	emit_signal("initialized")


func get_available_saveslots():
	var slots = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("earthsecrets-") and file.ends_with(".saveslot.json"):
			var saveslot = SaveSlot.new()
			saveslot.load_from_file(file)
			slots.append(saveslot)

	return slots


func on_initialized():
	is_initialized = true


func on_npc_triggered(npc:NPC):
	pass
