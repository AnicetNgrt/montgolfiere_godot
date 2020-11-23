extends Camera2D

export(float) var speed_mult_x = 60
export(float) var speed_mult_y = 25

var movement = Vector2.ZERO


func _physics_process(delta):
	movement = lerp(movement, Vector2.ZERO, 1)
	if $BorderTop.get_overlapping_bodies().size() > 0 and $DetectorTop.get_overlapping_areas().size() > 0:
		movement.y = delta*speed_mult_y * -0.01 * global_position.distance_to($BorderTop.get_overlapping_bodies()[0].global_position)
	
	if $BorderBottom.get_overlapping_bodies().size() > 0 and $DetectorBottom.get_overlapping_areas().size() > 0:
		movement.y = delta*speed_mult_y * 0.01 * global_position.distance_to($BorderBottom.get_overlapping_bodies()[0].global_position)
		
	if $BorderLeft.get_overlapping_bodies().size() > 0 and $DetectorLeft.get_overlapping_areas().size() > 0:
		movement.x = delta*speed_mult_x * -0.01 * global_position.distance_to($BorderLeft.get_overlapping_bodies()[0].global_position)
	
	if $BorderRight.get_overlapping_bodies().size() > 0 and $DetectorRight.get_overlapping_areas().size() > 0:
		movement.x = delta*speed_mult_x * 0.01 * global_position.distance_to($BorderRight.get_overlapping_bodies()[0].global_position)
	
	position += movement
