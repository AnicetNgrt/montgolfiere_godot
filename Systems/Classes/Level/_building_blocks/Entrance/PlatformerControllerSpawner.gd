class_name PlatformerControllerSpawner
extends Node2D

const PlatformerControllerPs = preload("res://Systems/Classes/PlatformerController/PlatformerController.tscn")

export(Resource) var spawnpoint_data
export(int) var layer
export(PlatformerController.Directions) var direction

func spawn_instance() -> PlatformerController:
	var character = PlatformerControllerPs.instance()
	character.global_position = global_position
	character.switch_layer(layer)
	character.set_direction(direction)
	return character
