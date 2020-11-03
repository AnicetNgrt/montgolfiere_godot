extends Camera2D

export(float) var speed_mult

var movement = Vector2.ZERO


func _physics_process(delta):
	movement = lerp(movement, Vector2.ZERO, 1)
	if $BorderTop.get_overlapping_bodies().size() > 0 and $DetectorTop.get_overlapping_areas().size() > 0:
		movement.y = speed_mult * -0.0001 * global_position.distance_to($BorderTop.get_overlapping_bodies()[0].global_position)
		
	if $BorderBottom.get_overlapping_bodies().size() > 0 and $DetectorBottom.get_overlapping_areas().size() > 0:
		movement.y = speed_mult * 0.0001 * global_position.distance_to($BorderBottom.get_overlapping_bodies()[0].global_position)
		
	if $BorderLeft.get_overlapping_bodies().size() > 0 and $DetectorLeft.get_overlapping_areas().size() > 0:
		movement.x = speed_mult * -0.0001 * global_position.distance_to($BorderLeft.get_overlapping_bodies()[0].global_position)
		
	if $BorderRight.get_overlapping_bodies().size() > 0 and $DetectorRight.get_overlapping_areas().size() > 0:
		movement.x = speed_mult * 0.0001 * global_position.distance_to($BorderRight.get_overlapping_bodies()[0].global_position)
		
	
	position += Vector2(floor(movement.x), floor(movement.y))
