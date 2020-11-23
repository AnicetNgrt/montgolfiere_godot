class_name NPC
extends Area2D


export(Resource) var profile setget set_profile

func set_profile(value):
	if not is_inside_tree(): yield(self, "ready")
	profile = value


func _on_NPC_body_entered(body):
	if body is Character:
		ProgressManager.on_npc_triggered(self)
		on_triggered()


func on_triggered():
	pass
