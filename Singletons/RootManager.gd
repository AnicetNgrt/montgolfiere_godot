extends Node

func add_child_deff(child:Node):
	get_tree().get_root().call_deferred("add_child", child)

func remove_child_deff(child:Node):
	get_tree().get_root().call_deferred("remove_child", child)
