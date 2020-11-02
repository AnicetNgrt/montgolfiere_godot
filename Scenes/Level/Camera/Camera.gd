extends Camera2D

var movement = Vector2.ZERO

func _physics_process(delta):
	movement = lerp(movement, Vector2.ZERO, 0.1)
	if $BorderTop.get_overlapping_bodies().size() > 0 and $DetectorTop.get_overlapping_areas().size() > 0:
		movement.y = -2
	if $BorderBottom.get_overlapping_bodies().size() > 0 and $DetectorBottom.get_overlapping_areas().size() > 0:
		movement.y = 2
	if $BorderLeft.get_overlapping_bodies().size() > 0 and $DetectorLeft.get_overlapping_areas().size() > 0:
		movement.x = -2
	if $BorderRight.get_overlapping_bodies().size() > 0 and $DetectorRight.get_overlapping_areas().size() > 0:
		movement.x = 2
	
	position += movement
