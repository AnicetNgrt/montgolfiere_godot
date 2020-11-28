class_name ProgressDB
extends Resource

# General progress
export(String) var spawnpoint = "earth1-default"
export(Array, Resource) var artifacts = []
export(Array, Resource) var clues = []

# Cutscene progress
export(bool) var saw_intro_cutscene = false

# NPC progress
export(Dictionary) var dialogues = {}


func to_dict() -> Dictionary:
	return {
		"general": {
			"spawnpoint": spawnpoint,
			"artifacts": artifacts,
			"clues": clues,
		},
		"cutscenes": {
			"intro": saw_intro_cutscene
		},
		"dialogues": dialogues
	}


func from_dict(dict:Dictionary):
	spawnpoint = dict["general"]["spawnpoint"]
	for key in dict["general"]["artifacts"]:
		artifacts.append(key)
	for key in dict["general"]["clues"]:
		clues.append(key)
	
	saw_intro_cutscene = dict["cutscenes"]["intro"]
	
	dialogues = dict["dialogues"]
