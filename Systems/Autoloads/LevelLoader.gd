extends Node

var current_level:Level = null

signal level_loaded()
signal level_unloaded()


func load_level(spawnpoint:SpawnPoint):
	UiSummoner.summon_transition_screen(0.2)
	yield(get_tree().create_timer(0.5),"timeout")
	if current_level != null:
		current_level.call_deferred("queue_free")
		emit_signal("level_unloaded")
	
	var new_level = load(spawnpoint.level_path).instance()
	call_deferred("add_child", new_level)
	new_level.do_self_spawn = false
	yield(new_level, "ready")
	
	new_level.enter_at(spawnpoint.name)
	
	if not new_level.is_ready_and_spawned: 
		yield(new_level, "ready_and_spawned")
	
	current_level = new_level
	
	emit_signal("level_loaded")


func unload_level():
	UiSummoner.summon_transition_screen(0.2)
	yield(get_tree().create_timer(0.5),"timeout")
	if current_level != null:
		current_level.call_deferred("queue_free")
	emit_signal("level_unloaded")
