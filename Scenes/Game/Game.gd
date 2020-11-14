class_name Game
extends Node


onready var stamina_bar = $UIlayer/UI/Character/StaminaBar

export(String, FILE) var default_level_path

var current_entity = null
var current_level = null
var current_entity_ui_position := Vector2(0, 0)

var time_last_charac_stamina_update = 0


func _physics_process(delta):
	var ticks_msec = OS.get_ticks_msec()

	if ticks_msec - time_last_charac_stamina_update > 1000 and stamina_bar:
		if stamina_bar.modulate.a == 1: TweensUtils.fadeout(stamina_bar)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	load_level(default_level_path, "default")


func load_level(level_path, sp_name):
	get_tree().paused = true
	if has_node("Level"):
		var prev_level = get_node("Level")
		prev_level.name = "PreviousLevel"
		call_deferred("remove_child", prev_level)
		prev_level.call_deferred("queue_free")

	var new_level = load(level_path).instance()
	call_deferred("add_child", new_level)
	new_level.connect("goto_level", self, "on_level_goto_level")
	new_level.connect("switch_entity", self, "on_level_switch_entity")
	new_level.name = "Level"
	new_level.do_self_spawn = false
	yield(new_level, "ready")
	new_level.enter_at(sp_name)
	get_tree().paused = false
	if not new_level.is_ready_and_spawned: 
		yield(new_level, "ready_and_spawned")
	current_level = new_level


func on_level_goto_level(data):
	load_level(data.level_path, data.name)


func on_level_switch_entity(entity):
	current_entity = entity
	if entity is Character:
		$UIlayer/UI/Character.show()
		entity.connect("stamina_changed", self, "on_character_stamina_changed")


func on_character_stamina_changed(stamina):
	time_last_charac_stamina_update = OS.get_ticks_msec()
	TweensUtils.interpolate_property(
		stamina_bar, 
		"value", 
		stamina_bar.value, 
		stamina - fmod(stamina, 0.926), 
		0.3, 
		null, 
		null
	)
	if stamina_bar.modulate.a == 0: 
		TweensUtils.fadein(stamina_bar)
