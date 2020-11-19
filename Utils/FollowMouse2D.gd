extends Node2D

export(Vector2) var follow_offset = Vector2.ZERO
export(float) var factor = 1
var initial_pos = null

func _process(delta):
	if not initial_pos:
		initial_pos = position

func _input(event):
   if event is InputEventMouseMotion:
	   _mouse_anim(event.position)

func _mouse_anim(mouse_pos:Vector2):
	if initial_pos != null:
		var screen_size = OS.get_window_safe_area().size
		position = initial_pos + 50 * factor * (mouse_pos/screen_size - position/screen_size - follow_offset/screen_size) 
