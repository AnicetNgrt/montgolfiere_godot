class_name ClimbAnchor
extends Area2D

export var scan_rate := 600

var last_scan = 0

func _physics_process(delta):
	if OS.get_ticks_msec() - last_scan > 6000/scan_rate:
		last_scan = OS.get_ticks_msec()
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body is PlatformerController:
				if body.can_climb() and (Input.is_action_pressed("climb") or not body.is_on_floor()):
					var s = sign(global_position.x-body.global_position.x)
					var tween = Tween.new()
					add_child(tween)
					tween.interpolate_property(
						body,
						"global_position", 
						body.global_position,
						global_position + Vector2(s*10, 40),
						0.40,
						Tween.TRANS_QUINT,
						Tween.EASE_OUT
					)
					tween.start()
					body.on_climbing_started(global_position)
					if tween.is_active(): yield(tween,"tween_completed")
					tween.interpolate_property(
						body,
						"global_position", 
						body.global_position,
						global_position + Vector2(s*10, 0),
						0.24,
						Tween.TRANS_LINEAR,
						Tween.EASE_IN
					)
					tween.start()
					if tween.is_active(): yield(tween,"tween_completed")
					body.on_climbing_finished(global_position)
