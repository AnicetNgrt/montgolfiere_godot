class_name Character
extends KinematicBody2D

export (Resource) var state
export (Resource) var physics_profile

enum Directions { LEFT = 0, RIGHT }

var wind_direction := Vector2(0, 0)
var velocity := Vector2.ZERO
var climbing := false

signal stamina_changed(stamina)
signal layer_changed(layer)

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
	if is_on_floor() and not climbing:# and state.stamina > 0:
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
		velocity = lerp(velocity, get_max_speed(), get_acceleration())
	else: 
		velocity = lerp(velocity, get_max_speed() * Vector2(-1, 0), get_acceleration())
	#velocity.y = lerp(velocity.y, -get_floor_normal().y, get_acceleration())
	velocity += physics_profile.ground_stick_factor*get_floor_normal()*-1
	if is_running(): 
		set_stamina_and_notify(state.stamina - state.run_stamina_loss_mult*delta)
		$Sprite.play("run")
	else: 
		set_stamina_and_notify(state.stamina - state.walk_stamina_loss_mult*delta)
		$Sprite.play("walk")


func on_walking_ended() -> void:
	if $Sprite.animation == "walk" or $Sprite.animation == "run":
		$Sprite.play("idle")


func update_movement(delta:float) -> void:
	var effective_wind
	velocity.y += physics_profile.gravity * delta
	if is_on_floor():
		effective_wind = Vector2(wind_direction.x, 0)
	else:
		effective_wind = wind_direction
	if $Sprite.animation == "jump" or $Sprite.animation == "idle":
		velocity += effective_wind * 0.5
	else:
		velocity += effective_wind
	velocity.x = lerp(velocity.x, 0, get_friction())
	velocity.y = lerp(velocity.y, 0, get_friction())
	velocity = move_and_slide(velocity, Vector2.UP)


func update_jump(delta:float) -> void:
	if is_on_floor() and $Sprite.animation == "jump":
		$Sprite.play("idle")
		play_footstep()
	if not is_on_floor() and $Sprite.animation == "jump":
		if $Sprite.flip_h:
			velocity.x += 4
		else:
			velocity.x -= 4
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and !climbing:
			$Sprite.play("jump")
			velocity.y = -physics_profile.jump_speed
			if is_running():
				set_stamina_and_notify(state.stamina - state.jump_run_stamina_loss)
			else:
				set_stamina_and_notify(state.stamina - state.jump_stamina_loss)
			play_footstep()


func on_climbing_started(towards:Vector2):
	climbing = true
	$Sprite.play("climb")
	$Sprite.flip_h = global_position.x < towards.x
	set_stamina_and_notify(state.stamina - state.climb_stamina_loss)
	play_footstep()


func on_climbing_finished(towards:Vector2):
	climbing = false
	play_footstep()
	#$Sprite.play("idle")


func _on_Sprite_frame_changed():
	var anim = $Sprite.animation
	if (anim == "run" || anim == "walk") && is_on_floor() && $Sprite.frame % 3 == 0:
		play_footstep()


func play_footstep():
	var sound_player = RandomUtils.get_random_child($FootstepSounds)
	sound_player.play()

func get_friction() -> float:
	if is_on_floor():
		return physics_profile.friction_floor
	else:
		return physics_profile.friction_air


func get_max_speed() -> Vector2:
	if is_running():
		return physics_profile.max_speed_running# * lerp(state.stamina/state.max_stamina, 1, 0.4)
	else:
		return physics_profile.max_speed_walking# * lerp(state.stamina/state.max_stamina, 1, 0.4)


func get_acceleration() -> float:
	if is_running():
		return physics_profile.acceleration_running
	else:
		return physics_profile.acceleration_walking


func is_running() -> bool:
	return Input.is_action_pressed("run") and state.stamina > 0


func can_climb() -> bool:
	return !climbing


func switch_layer(layer:int):
	set_collision_layer_bit(layer+5, true)
	for i in range(5, 15):
		if i != layer+5: set_collision_layer_bit(i, false)
	emit_signal("layer_changed", layer)


func set_direction(direction:int):
	$Sprite.flip_h = direction == Directions.RIGHT


func set_stamina_and_notify(value):
	pass
	#var new_stamina = clamp(value, 0, state.max_stamina)
	#if new_stamina != state.stamina:
	#	emit_signal("stamina_changed", new_stamina)
	#state.stamina = new_stamina
