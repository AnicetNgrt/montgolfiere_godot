extends KinematicBody2D

export (int) var speed = 1200
export (int) var jump_speed = -1800
export (int) var gravity = 4000

var velocity = Vector2.ZERO

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += speed
		$Sprite.flip_h = true
		$Sprite.play("run")
	elif Input.is_action_pressed("walk_left"):
		velocity.x -= speed
		$Sprite.flip_h = false
		$Sprite.play("run")
	else:
		$Sprite.play("idle")

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
