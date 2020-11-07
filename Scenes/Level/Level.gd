class_name Level
extends Node2D

signal ready_and_spawned()
signal goto_level(key)


export(bool) var do_self_spawn = true 
export(String) var default_spawn = ""


func _ready():
	if do_self_spawn and default_spawn != "":
		enter_at(default_spawn)
		pass
	for exit in $Exits.get_children():
		exit.connect("body_exited", self, "on_exit_body_exited")


#func _physics_process(delta):
#	print($Background.offset)


func on_exit_body_exited(body:Node, key:String) -> void:
	emit_signal("goto_level", key)


func enter_at(key:String):
	var spawner = null
	for c in get_children():
		if c is CharacterSpawner:
			if c.key == key: spawner = c
	if spawner:
		var instance:Node = spawner.spawn_instance()
		print(instance)
		#if not instance.is_inside_tree(): yield(instance, "ready")
		add_child_below_node(spawner, instance)
		print(spawner.get_children())
		if spawner.has_node("CameraAnchor"):
			print("hre")
			$Camera.global_position = spawner.get_node("CameraAnchor").global_position
		emit_signal("ready_and_spawned")
