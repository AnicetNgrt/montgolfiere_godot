class_name ProgressDB
extends Resource

# General progress
export(String) var spawnpoint = "earth1-default"
export(Array, Resource) var artifacts = []
export(Array, Resource) var clues = []
export(Resource) var balloon_skin = preload("res://Systems/Classes/Map/Balloon/BalloonSkin/_instances/regular.tres")

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
	spawnpoint = dict.get("general", {}).get("spawnpoint", null)
	for key in dict.get("general", {}).get("artifacts", []):
		artifacts.append(key)
	for key in dict.get("general", {}).get("clues", []):
		clues.append(key)
	
	saw_intro_cutscene = dict.get("cutscenes", {}).get("intro", false)
	
	dialogues = dict.get("dialogues", {})
