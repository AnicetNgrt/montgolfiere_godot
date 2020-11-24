class_name PlatformerController
extends KinematicBody2D

enum Directions { LEFT = 0, RIGHT }

var physics_profile
var character
var wind_direction := Vector2(0, 0)
var velocity := Vector2.ZERO
var climbing := false
var last_breathe = OS.get_ticks_msec()
var searching := false


signal stamina_changed(stamina)
signal layer_changed(layer)


func _ready():
	$Sprite.play("idle")


func _physics_process(delta:float):
	get_input(delta)
	update_jump(delta)
	update_movement(delta)


func get_input(delta:float):
	handle_walking(delta)
	if Input.is_action_pressed("search") and not searching and velocity.distance_to(Vector2.ZERO) < 0.5:
		start_searching()
	elif not Input.is_action_pressed("search") and searching:
		end_searching()


func handle_walking(delta:float) -> void:
	var state = ProgressManager.platformer_controller_state
	var breathe_sep = 100000
	if state.stamina <= 10:
		breathe_sep = 1000
	
	if OS.get_ticks_msec() - last_breathe > breathe_sep:
		play_breathe()
		last_breathe = OS.get_ticks_msec()
	
	if is_on_floor() and not climbing:
		if Input.is_action_pressed("walk_right"):
			on_walking_started(Directions.RIGHT, delta)
		elif Input.is_action_pressed("walk_left"):
			on_walking_started(Directions.LEFT, delta)
		else:
			if state.stamina + state.stamina_recovery <= state.max_stamina:
				state.stamina += state.stamina_recovery
			on_walking_ended()
	else:
		on_walking_ended()


func on_walking_started(direction:int, delta:float) -> void:
	var state = ProgressManager.platformer_controller_state
	$Sprite.flip_h = direction == Directions.RIGHT
	if direction == Directions.RIGHT:
		velocity = lerp(velocity, get_max_speed(), get_acceleration())
	else: 
		velocity = lerp(velocity, get_max_speed() * Vector2(-1, 0), get_acceleration())
	#velocity.y = lerp(velocity.y, -get_floor_normal().y, get_acceleration())
	velocity += physics_profile.ground_stick_factor*get_floor_normal()*-1
	if is_running():
		state.stamina -= state.run_stamina_loss
		$Sprite.play("walk")
		$Sprite.speed_scale = 1.5
	else:
		if state.stamina + state.walk_stamina_recovery <= state.max_stamina:
			state.stamina += state.walk_stamina_recovery
		$Sprite.play("walk")
		$Sprite.speed_scale = 1


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
			play_footstep()


func on_climbing_started(towards:Vector2):
	climbing = true
	$Sprite.play("climb")
	$Sprite.flip_h = global_position.x < towards.x
	play_footstep()


func on_climbing_finished(towards:Vector2):
	climbing = false
	play_footstep()
	#$Sprite.play("idle")


func play_footstep():
	var sound_player = RandomUtils.get_random_child($FootstepSounds)
	while sound_player.playing:
		sound_player = RandomUtils.get_random_child($FootstepSounds)
	sound_player.play()


func play_breathe():
	var sound_player = RandomUtils.get_random_child($BreatheSounds)
	while sound_player.playing:
		sound_player = RandomUtils.get_random_child($BreatheSounds)
	sound_player.play()


func get_friction() -> float:
	if is_on_floor():
		return physics_profile.friction_floor
	else:
		return physics_profile.friction_air


func get_max_speed() -> Vector2:
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
	return Input.is_action_pressed("run") #and ProgressManager.platformer_controller_state.stamina > 0


func can_climb() -> bool:
	return !climbing and !is_on_floor() and (abs(velocity.x) > 250 or velocity.y < 0) #and ProgressManager.platformer_controller_state.stamina > 0


func switch_layer(layer:int):
	set_collision_layer_bit(layer+5, true)
	for i in range(5, 15):
		if i != layer+5: set_collision_layer_bit(i, false)
	emit_signal("layer_changed", layer)


func set_direction(direction:int):
	$Sprite.flip_h = direction == Directions.RIGHT


func set_stamina_and_notify(value):
	pass
	#var new_stamina = clamp(value, 0, ProgressManager.platformer_controller_state.max_stamina)
	#if new_stamina != ProgressManager.platformer_controller_state.stamina:
	#	emit_signal("stamina_changed", new_stamina)
	#ProgressManager.platformer_controller_state.stamina = new_stamina


func start_searching():
	searching = true
	$Sprite.play("start_searching")


func end_searching():
	searching = false
	$Sprite.play("end_searching")


func _on_Sprite_frame_changed():
	var anim = $Sprite.animation
	if (anim == "run" || anim == "walk") && is_on_floor() && $Sprite.frame % 3 == 0:
		play_footstep()
