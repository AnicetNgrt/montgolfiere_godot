extends Node

var ui_layer: CanvasLayer
var region_title_path = "res://Scenes/UI/RegionTitle/RegionTitle.tscn"
var transition_screen_path = "res://Scenes/UI/TransitionScreen/TransitionScreen.tscn"
var dashboard_path = "res://Scenes/UI/Dashboard/Dashboard.tscn"


var dashboard = null


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	ui_layer = CanvasLayer.new()
	ui_layer.pause_mode = PAUSE_MODE_PROCESS
	RootManager.add_child_deff(ui_layer)


func _input(event):
	if Input.is_action_just_pressed("open_dashboard"):
		if dashboard == null: summon_dashboard()
		elif Input.is_action_just_pressed("close"):
			close_dashboard()
	elif Input.is_action_just_pressed("close"):
		if dashboard != null: 
			close_dashboard()


func summon_dashboard():
	dashboard = summon(dashboard_path, ui_layer)
	get_tree().paused = true


func close_dashboard():
	dashboard.emit_signal("finished", dashboard)
	get_tree().paused = false
	dashboard = null


func summon_region_title(title:String):
	var region_title = summon(region_title_path, ui_layer)
	region_title.title = title


func summon_transition_screen(duration:float):
	var screen = summon(transition_screen_path, ui_layer)
	TweensUtils.fadein(screen, 0.5)
	yield(get_tree().create_timer(duration+0.5),"timeout")
	TweensUtils.fadeout(screen, 0.5)
	yield(get_tree().create_timer(0.5),"timeout")
	screen.emit_signal("finished", screen)


func summon(path:String, parent:Node) -> Control:
	var ControlPS = load(path)
	var instance: Control = ControlPS.instance()
	parent.call_deferred("add_child", instance)
	connect_ui_instance(instance)
	return instance
	

func connect_ui_instance(instance:Node):
	instance.connect("finished", self, "on_ui_instance_finished")


func on_ui_instance_finished(instance:Node):
	instance.call_deferred("queue_free")
