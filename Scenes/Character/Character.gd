extends KinematicBody2D

export (int) var speed := 0
export (int) var jump_speed := 0
export (int) var gravity := 0

enum Directions { LEFT = 0, RIGHT }

var velocity := Vector2.ZERO

func get_input():
	if Input.is_action_pressed("walk_right"):
		on_running_started(Directions.RIGHT)
	elif Input.is_action_pressed("walk_left"):
		on_running_started(Directions.LEFT)
	else:
		on_running_ended()


func _physics_process(delta:float):
	get_input()
	update_jump(delta)


func on_running_started(direction:int) -> void:
	$Sprite.play("run")
	$Sprite.flip_h = direction == Directions.RIGHT
	if direction == Directions.RIGHT: velocity.x += speed
	else: velocity.x -= speed


func on_running_ended() -> void:
	$Sprite.play("idle")
	velocity.x = 0


func update_jump(delta:float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
