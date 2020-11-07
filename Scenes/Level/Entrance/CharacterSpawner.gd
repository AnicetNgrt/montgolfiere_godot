class_name CharacterSpawner
extends Node2D

const CharacterPs = preload("res://Scenes/Character/Character.tscn")

export(String) var key
export(int) var layer
export(Character.Directions) var direction

func spawn_instance() -> Character:
	var character = CharacterPs.instance()
	character.global_position = global_position
	character.switch_layer(layer)
	character.set_direction(direction)
	return character
