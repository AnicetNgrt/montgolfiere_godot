tool
class_name BackgroundLayer
extends Sprite

export(float) var speed setget set_speed

func set_speed(val):
	speed = val
	if material:
		material.set("shader_param/scroll_speed", speed)
