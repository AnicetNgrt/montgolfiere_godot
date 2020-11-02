extends Area2D

export var scan_rate := 600

var last_scan = 0

func _physics_process(delta):
	if OS.get_ticks_msec() - last_scan > 6000/scan_rate:
		last_scan = OS.get_ticks_msec()
		print("scanning")
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if not body is Character: return
			if body.can_climb() and Input.is_action_pressed("climb"):
				var tween = Tween.new()
				add_child(tween)
				tween.interpolate_property(
					body,
					"global_position", 
					body.global_position,
					global_position + Vector2(0, 20),
					0.48,
					Tween.TRANS_QUINT,
					Tween.EASE_OUT
				)
				tween.start()
				body.on_climbing_started(global_position)
				yield(tween,"tween_completed")
				tween.interpolate_property(
					body,
					"global_position", 
					body.global_position,
					global_position,
					0.48,
					Tween.TRANS_QUINT,
					Tween.EASE_OUT
				)
				tween.start()
				yield(tween,"tween_completed")
				body.on_climbing_finished(global_position)
