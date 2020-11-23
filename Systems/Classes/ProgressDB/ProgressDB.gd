class_name ProgressDB
extends Resource

# General progress
export(Resource) var spawnpoint
export(Array, Resource) var artifacts
export(Array, Resource) var clues

# Cutscene progress
export(bool) var saw_intro_cutscene

# NPC progress
export(bool) var the_savant_met


func to_dict() -> Dictionary:
	return {
		"general": {
			"spawnpoint_path": spawnpoint.resource_path,
			"artifacts_paths": [],
			"clues_paths": [],	
		},
		"cutscenes": {
			"intro": saw_intro_cutscene
		},
		"npcs": {
			"the_savant": {
				"met": the_savant_met
			}
		}
	}


func from_dict(dict:Dictionary):
	spawnpoint = load(dict["general"]["spawnpoint_path"])
	for path in dict["general"]["artifacts_paths"]:
		artifacts.append(load(path))
	for path in dict["general"]["clues_paths"]:
		clues.append(load(path))
	
	saw_intro_cutscene = dict["cutscenes"]["intro"]
	
	the_savant_met = dict["npcs"]["the_savant"]["met"]
