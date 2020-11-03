class_name Level
extends Node2D

const LEVELS_DIR = "res://Scenes/Level/Levels/"

export(Dictionary) var next_levels = {}

signal goto_level(level)

func _ready():
	for exit in $Exits.get_children():
		exit.connect("body_exited", self, "on_exit_body_exited")


func on_exit_body_exited(body:Node, key:String) -> void:
	emit_signal("goto_level", LEVELS_DIR+next_levels[key])
