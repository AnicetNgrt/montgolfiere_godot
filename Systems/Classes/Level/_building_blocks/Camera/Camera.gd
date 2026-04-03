extends Camera2D

export(float) var speed_mult_x = 60
export(float) var speed_mult_y = 25

var movement = Vector2.ZERO


func _physics_process(delta):
	movement = lerp(movement, Vector2.ZERO, 1)
	var top_bodies = $BorderTop.get_overlapping_bodies()
	var bot_bodies = $BorderBottom.get_overlapping_bodies()
	var left_bodies = $BorderLeft.get_overlapping_bodies()
	var right_bodies = $BorderRight.get_overlapping_bodies()

	if top_bodies.size() > 0 and $DetectorTop.get_overlapping_areas().size() > 0:
		var dist = global_position.distance_to(top_bodies[0].global_position)
		movement.y = delta * speed_mult_y * -0.01 * dist

	if bot_bodies.size() > 0 and $DetectorBottom.get_overlapping_areas().size() > 0:
		var dist = global_position.distance_to(bot_bodies[0].global_position)
		movement.y = delta * speed_mult_y * 0.01 * dist

	if left_bodies.size() > 0 and $DetectorLeft.get_overlapping_areas().size() > 0:
		var dist = global_position.distance_to(left_bodies[0].global_position)
		movement.x = delta * speed_mult_x * -0.01 * dist

	if right_bodies.size() > 0 and $DetectorRight.get_overlapping_areas().size() > 0:
		var dist = global_position.distance_to(right_bodies[0].global_position)
		movement.x = delta * speed_mult_x * 0.01 * dist

	position += movement
