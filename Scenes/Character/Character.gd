class_name Character
extends KinematicBody2D

export (Resource) var state
export (Resource) var physics_profile

enum Directions { LEFT = 0, RIGHT }

var velocity := Vector2.ZERO
var climbing := false

signal stamina_changed(stamina)

func _ready():
	state.stamina = state.max_stamina
	$Sprite.play("idle")


func _physics_process(delta:float):
	get_input(delta)
	update_jump(delta)
	update_movement(delta)


func get_input(delta:float):
	handle_walking(delta)


func handle_walking(delta:float) -> void:
	if is_on_floor() and not climbing and state.stamina > 0:
		if Input.is_action_pressed("walk_right"):
			on_walking_started(Directions.RIGHT, delta)
		elif Input.is_action_pressed("walk_left"):
			on_walking_started(Directions.LEFT, delta)
		else:
			on_walking_ended()
	else:
		on_walking_ended()


func on_walking_started(direction:int, delta:float) -> void:
	$Sprite.flip_h = direction == Directions.RIGHT
	if direction == Directions.RIGHT:
# lerp -> on prend le point au centre du segment (velocity.x maxspeed)
#		cad qu'on tend peu a peu vers maxspeed en partant de velocity.x
		velocity.x = lerp(velocity.x, get_max_speed(), get_acceleration())
	else: 
		velocity.x = lerp(velocity.x, -get_max_speed(), get_acceleration())
	
	if is_running(): 
		self.state.stamina -= state.run_stamina_loss_mult*delta
		$Sprite.play("run")
	else: 
		self.state.stamina -= state.walk_stamina_loss_mult*delta
		$Sprite.play("walk")


func on_walking_ended() -> void:
	if $Sprite.animation == "walk" or $Sprite.animation == "run":
		$Sprite.play("idle")
	velocity.x = lerp(velocity.x, 0, get_friction())


func update_movement(delta:float) -> void:
	velocity.y += physics_profile.gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func update_jump(delta:float) -> void:
	if is_on_floor() and $Sprite.animation == "jump":
		$Sprite.play("idle")
	if not is_on_floor() and $Sprite.animation == "jump":
		if $Sprite.flip_h:
			velocity.x += 4
		else:
			velocity.x -= 4
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and state.stamina > 0:
			$Sprite.play("jump")
			velocity.y = -physics_profile.jump_speed
			if is_running():
				set_stamina_and_notify(state.stamina - state.jump_run_stamina_loss)
			else:
				set_stamina_and_notify(state.stamina - state.jump_stamina_loss)


func on_climbing_started(towards:Vector2):
	climbing = true
	$Sprite.play("climb")
	$Sprite.flip_h = global_position.x < towards.x
	set_stamina_and_notify(state.stamina - state.climb_stamina_loss)


func on_climbing_finished(towards:Vector2):
	climbing = false
	#$Sprite.play("idle")


func _on_Sprite_frame_changed():
	var anim = $Sprite.animation
	if (anim == "run" || anim == "walk") && is_on_floor() && $Sprite.frame % 3 == 0:
		var sound_player = RandomUtils.get_random_child($FootstepSounds)
		sound_player.play()


func get_friction() -> float:
	if is_on_floor():
		return physics_profile.friction_floor
	else:
		return physics_profile.friction_air


func get_max_speed() -> int:
	if is_running():
		return physics_profile.max_speed_running
	else:
		return physics_profile.max_speed_walking


func get_acceleration() -> float:
	if is_running():
		return physics_profile.acceleration_running
	else:
		return physics_profile.acceleration_walking


func is_running() -> bool:
	return Input.is_action_pressed("run")


func can_climb() -> bool:
	return !climbing and state.stamina > 0


func switch_layer(layer:int):
	set_collision_layer_bit(layer+5, true)
	for i in range(5, 15):
		if i != layer+5: set_collision_layer_bit(i, false)
	print("switched to "+str(layer))


func set_direction(direction:int):
	$Sprite.flip_h = direction == Directions.RIGHT


func set_stamina_and_notify(value):
	state.stamina = value
	emit_signal("stamina_changed", state.stamina)
	#if not is_inside_tree(): yield(self, "ready")
