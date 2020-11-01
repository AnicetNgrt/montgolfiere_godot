tool
extends Sprite

export(float) var speed setget set_speed

func set_speed(val):
	speed = val
	material.set("shader_param/scroll_speed", speed)
