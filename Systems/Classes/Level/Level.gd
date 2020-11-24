tool
class_name Level
extends Node2D

onready var day_night_animator = $DayNightAnimator

export(bool) var do_self_spawn = true 
export(String) var default_spawn = ""
export(Color) var custom_modulate = Color.white setget set_custom_modulate
export(Resource) var region #: Region

var is_ready_and_spawned = false


func _physics_process(delta):
	if day_night_animator and day_night_animator.current_animation == "day_night":
		region.time_of_day = day_night_animator.current_animation_position/day_night_animator.current_animation_length


func _ready():
	day_night_animator.add_animation("day_night", region.day_night_anim)
	if !Engine.is_editor_hint():
		if do_self_spawn and default_spawn != "":
			RootManager.remove_child_deff(self)
			LevelLoader.call_deferred("add_child", self)
			LevelLoader.current_level = self
			enter_at(default_spawn)


func on_exit_body_exited(body:Node, data:Resource) -> void:
	emit_signal("goto_level", data)


func enter_at(key:String):
	var spawner = null
	for c in get_children():
		if c is PlatformerControllerSpawner:
			if c.spawnpoint_data.name == key: 
				spawner = c
				break

	if spawner:
		var instance:Node = spawner.spawn_instance()
		#if not instance.is_inside_tree(): yield(instance, "ready")
		add_child_below_node(spawner, instance)
		if spawner.has_node("CameraAnchor"):
			$Camera.global_position = spawner.get_node("CameraAnchor").global_position
		is_ready_and_spawned = true
		
		if not region.is_inside:
			region.is_inside = true
			on_region_enter(spawner.spawnpoint_data)
		
		region.connect("play_daynight", self, "on_region_play_daynight")
		region.connect("pause_daynight", self, "on_region_pause_daynight")
		region.play_daynight()
		day_night_animator.seek(day_night_animator.current_animation_length*region.time_of_day)
		
		if instance is PlatformerController:
			instance.connect("layer_changed", self, "on_character_layer_changed")
			instance.physics_profile = region.physics_profile


func on_region_play_daynight():
	day_night_animator.play("day_night", -1, 0.3)
	print(day_night_animator.current_animation_length*region.time_of_day)
	day_night_animator.seek(day_night_animator.current_animation_length*region.time_of_day)


func on_region_pause_daynight():
	day_night_animator.stop()


func on_region_enter(spawnpoint):
	region.checkpoint = spawnpoint
	MusicManager.play_music(region.theme, region.theme_volume)
	WorldEnvManager.set_environment(region.environment)
	yield(get_tree().create_timer(1), "timeout")
	UiSummoner.summon_region_title(region.map_name)


func set_custom_modulate(value):
	custom_modulate = value
	if not is_inside_tree(): yield(self, "ready")
	self.modulate = value
	for c in get_children():
		if c is ParallaxBackground:
			for layer in c.get_children():
				if layer is ParallaxLayer:
					layer.modulate = value


func on_character_layer_changed(layer:int):
	move_child(get_node("Character"), get_node("layer"+str(layer)).get_index())


func _on_DayNightAnimator_animation_finished(anim_name):
	region.time_of_day = 0
	LevelLoader.load_level(region.checkpoint)
