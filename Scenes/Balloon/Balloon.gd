extends KinematicBody2D

export(int) var ACCELERATION = 500
export(int) var MAX_SPEED = 80
export(int) var FRICTION = 500
export(float) var MAX_ANGLE_DEGREE = 5

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_action_balloon()
	move_balloon(delta, input_vector)
	balloon_rotation(input_vector)

func get_action_balloon():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right_balloon") - Input.get_action_strength("left_balloon")
	input_vector.y = Input.get_action_strength("down_balloon") - Input.get_action_strength("up_balloon")
	return input_vector.normalized()

func move_balloon(delta, input_vector):
	if input_vector != Vector2.ZERO:
		velocity=velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity=velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

func balloon_rotation (vector):
	if vector.x > 0:
		self.rotation_degrees = min(self.rotation_degrees + 0.05, MAX_ANGLE_DEGREE)
	elif vector.x < 0:
		self.rotation_degrees = max(self.rotation_degrees - 0.05, -MAX_ANGLE_DEGREE)
	else:
		if self.rotation_degrees > 0:
			self.rotation_degrees = self.rotation_degrees - min(0.05,abs(self.rotation_degrees))
		elif self.rotation_degrees < 0:
			self.rotation_degrees = self.rotation_degrees + min(0.05,abs(self.rotation_degrees))
