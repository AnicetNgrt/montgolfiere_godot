tool
class_name Level
extends Node2D

signal ready_and_spawned()
signal goto_level(key)
signal switch_entity(character)


export(bool) var do_self_spawn = true 
export(String) var default_spawn = ""
export(Color) var custom_modulate = Color.white setget set_custom_modulate

var is_ready_and_spawned = false


func _ready():
	if !Engine.is_editor_hint():
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
			if c.key == key: 
				spawner = c
				break

	if spawner:
		var instance:Node = spawner.spawn_instance()
		#if not instance.is_inside_tree(): yield(instance, "ready")
		add_child_below_node(spawner, instance)
		if spawner.has_node("CameraAnchor"):
			$Camera.global_position = spawner.get_node("CameraAnchor").global_position
		emit_signal("ready_and_spawned")
		is_ready_and_spawned = true
		if instance is Character:
			emit_signal("switch_entity", instance)


func set_custom_modulate(value):
	custom_modulate = value
	if not is_inside_tree(): yield(self, "ready")
	self.modulate = value
	for c in get_children():
		if c is ParallaxBackground:
			for layer in c.get_children():
				if layer is ParallaxLayer:
					layer.modulate = value
