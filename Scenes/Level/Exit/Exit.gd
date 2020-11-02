class_name Exit
extends Node2D

export(String) var key = ""


signal body_exited(body, key)

func _ready():
	for c in get_children():
		if c is Area2D:
			var area:Area2D = c
			area.connect("body_entered", self, "on_area_body_entered")


func on_area_body_entered(body:Node) -> void:
	self.emit_signal("body_exited", body, key)
