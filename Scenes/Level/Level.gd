class_name Level
extends Node2D

export(Dictionary) var next_levels = {}

signal goto_level(level)


func _ready():
	for exit in $Exits.get_children():
		exit.connect("body_exited", self, "on_exit_body_exited")


func on_exit_body_exited(body:Node, key:String) -> void:
	pass
