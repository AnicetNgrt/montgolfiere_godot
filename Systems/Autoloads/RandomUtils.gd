extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func get_random_child(node:Node) -> Node:
	return node.get_child(rng.randi_range(0, node.get_child_count()-1))
