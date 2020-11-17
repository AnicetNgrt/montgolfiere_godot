extends Node

var ui_layer: Node 
var region_title_path = "res://Scenes/UI/RegionTitle/RegionTitle.tscn"

func _ready():
	ui_layer = CanvasLayer.new()
	get_tree().get_root().call_deferred("add_child", ui_layer)

func summon_region_title(title:String):
	var region_title = summon(region_title_path, ui_layer)
	region_title.title = title
	

func summon(path:String, parent:Node) -> Control:
	var ControlPS = load(path)
	var instance: Control = ControlPS.instance()
	parent.call_deferred("add_child", instance)
	instance.owner = parent
	connect_ui_instance(instance)
	return instance
	

func connect_ui_instance(instance:Node):
	instance.connect("finished", self, "on_ui_instance_finished")

func on_ui_instance_finished(instance:Node):
	instance.get_parent().call_deferred("remove_child", instance)
	instance.call_deferred("queue_free")
