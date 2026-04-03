extends Node

var current_level

func _ready():
	pass


func _on_Control_finished(_instance):
	$ParallaxBackground.call_deferred("queue_free")
	$Camera2D.call_deferred("queue_free")


func _on_Control_game_loaded():
	$ParallaxBackground.call_deferred("queue_free")
	$Camera2D.call_deferred("queue_free")
