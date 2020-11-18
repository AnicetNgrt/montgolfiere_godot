extends Node

var world_env := WorldEnvironment.new()

func _ready():
	RootManager.add_child_deff(world_env)

func set_environment(env:Environment):
	world_env.environment = env
