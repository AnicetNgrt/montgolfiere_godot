extends KinematicBody2D

export (int) var speed := 0
export (int) var jump_speed := 0
export (int) var gravity := 0

const ACCELERATION = 50
const FRICTION = 0

enum Directions { LEFT = 0, RIGHT }

var velocity := Vector2.ZERO

func get_input(delta:float):
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		on_running_started(Directions.RIGHT, delta)
	elif Input.is_action_pressed("walk_left"):
		on_running_started(Directions.LEFT, delta)
	else:
		on_running_ended()


func _physics_process(delta:float):
	get_input(delta)
	update_jump(delta)


func on_running_started(direction:int, delta:float) -> void:
	$Sprite.play("run")
	$Sprite.flip_h = direction == Directions.RIGHT
	if direction == Directions.RIGHT: velocity.x += speed
	else: velocity.x -= speed


func on_running_ended() -> void:
	$Sprite.play("idle")


func update_jump(delta:float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
