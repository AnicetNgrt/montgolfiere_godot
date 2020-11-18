class_name Exit
extends Area2D

export(Resource) var spawnpoint

func _ready():
	connect("body_entered", self, "on_body_entered")


func on_body_entered(body:Node) -> void:
	LevelLoader.load_level(spawnpoint)
