tool
extends Control

export(String) var title setget set_title

signal finished(instance)

func set_title(val):
	title = val
	if not is_inside_tree(): yield(self, "ready")
	$TitleContainer/Title.text = title

func _ready():
	$AnimationPlayer.play("in")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("finished", self)
