extends KinematicBody2D

export(int) var ACCELERATION = 500
export(int) var MAX_SPEED = 80
export(int) var FRICTION = 500
export(float) var MAX_ANGLE_DEGREE = 5

export(float) var WIND_STRENGHT = 2
export(float) var ARTIFACT_DURATION = 2.0

export(Array, Resource) var cards = []
var wind:Vector2
onready var Wind_time:Timer = $WindTimer

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_action_balloon()
	move_balloon(delta, input_vector)
	balloon_rotation(input_vector)
	
	if(Input.is_action_pressed("use_artifact")):
		start_wind()

func get_action_balloon():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right_balloon") - Input.get_action_strength("left_balloon")
	input_vector.y = Input.get_action_strength("down_balloon") - Input.get_action_strength("up_balloon")
	return input_vector.normalized()

func move_balloon(delta, input_vector:Vector2):
	if input_vector != Vector2.ZERO:
		velocity=velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity=velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity + (wind * WIND_STRENGHT))

func balloon_rotation (vector:Vector2):
	if vector.x > 0:
		self.rotation_degrees = min(self.rotation_degrees + 0.05, MAX_ANGLE_DEGREE)
	elif vector.x < 0:
		self.rotation_degrees = max(self.rotation_degrees - 0.05, -MAX_ANGLE_DEGREE)
	else:
		if self.rotation_degrees > 0:
			self.rotation_degrees = self.rotation_degrees - min(0.05,abs(self.rotation_degrees))
		elif self.rotation_degrees < 0:
			self.rotation_degrees = self.rotation_degrees + min(0.05,abs(self.rotation_degrees))

func start_wind():
	if(Wind_time.is_stopped() and cards.size() != 0):
		if(cards[-1].direction == Artifact.Directions.N_EAST or cards[-1].direction == Artifact.Directions.EAST or cards[-1].direction == Artifact.Directions.S_EAST):
			wind.x = 1
		if(cards[-1].direction == Artifact.Directions.N_WEST or cards[-1].direction == Artifact.Directions.WEST or cards[-1].direction == Artifact.Directions.S_WEST):
			wind.x = -1
		if(cards[-1].direction == Artifact.Directions.S_WEST or cards[-1].direction == Artifact.Directions.SOUTH or cards[-1].direction == Artifact.Directions.S_EAST):
			wind.y = 1
		if(cards[-1].direction == Artifact.Directions.N_EAST or cards[-1].direction == Artifact.Directions.NORTH or cards[-1].direction == Artifact.Directions.N_WEST):
			wind.y = -1
		wind.normalized()
		Wind_time.start(ARTIFACT_DURATION)
		cards.pop_back()

func _on_Timer_timeout():
	wind = Vector2.ZERO
	Wind_time.stop()
