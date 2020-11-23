extends Control

export(float) var factor = 1
var initial_pos = null

func _process(delta):
	if not initial_pos:
		initial_pos = rect_position

func _input(event):
   if event is InputEventMouseMotion:
	   _mouse_anim(event.position)

func _mouse_anim(mouse_pos:Vector2):
	if initial_pos:
		rect_position = initial_pos + (0.05 * factor * (mouse_pos - rect_position)) - (rect_size/20)
