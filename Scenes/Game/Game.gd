class_name Game
extends Node


onready var stamina_bar = $UIlayer/UI/Character/StaminaBar

var current_entity = null
var current_level = null
var current_entity_ui_position := Vector2(0, 0)

var time_last_charac_stamina_update = 0


var levels_connections = {
	"test0-0a":"res://Scenes/Levels/Test/LevelTest0.tscn"
}


func _physics_process(delta):
	var ticks_msec = OS.get_ticks_msec()
	#print(current_level)
	if current_entity is Character and current_level and stamina_bar:
		var pos = current_entity.position - current_level.get_node("Camera").get_camera_position()
		current_entity_ui_position = pos/1.7 + Vector2(935, 400)
		stamina_bar.rect_position = current_entity_ui_position
	
	if ticks_msec - time_last_charac_stamina_update > 1000 and stamina_bar:
		if stamina_bar.modulate.a == 1: TweensUtils.fadeout(self, stamina_bar)


func _ready():
	load_level("res://Scenes/Levels/Beginning/Home.tscn", "default")


func load_level(level_path:String, entrance_key:String):
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
	new_level.enter_at(entrance_key)
	get_tree().paused = false
	if not new_level.is_ready_and_spawned: 
		yield(new_level, "ready_and_spawned")
	current_level = new_level


func on_level_goto_level(entrance_key:String):
	load_level(levels_connections[entrance_key], entrance_key)


func on_level_switch_entity(entity):
	current_entity = entity
	if entity is Character:
		$UIlayer/UI/Character.show()
		entity.connect("stamina_changed", self, "on_character_stamina_changed")


func on_character_stamina_changed(stamina):
	time_last_charac_stamina_update = OS.get_ticks_msec()
	stamina_bar.value = stamina
	if stamina_bar.modulate.a == 0: 
		TweensUtils.fadein(self, stamina_bar)
