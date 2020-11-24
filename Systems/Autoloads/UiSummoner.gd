extends Node

signal cutscene_finished(cutscene)

var ui_layer: CanvasLayer
var cutscene_layer: CanvasLayer
var region_title_path = "res://Systems/Classes/UI/_building_blocks/RegionTitle/RegionTitle.tscn"
var transition_screen_path = "res://Systems/Classes/UI/_building_blocks/TransitionScreen/TransitionScreen.tscn"
var dashboard_path = "res://Systems/Classes/UI/_building_blocks/Dashboard/Dashboard.tscn"
#var main_menu_path = "res://Systems/Classes/UI/_building_blocks/MainMenu/MainMenu.tscn"

var dashboard = null
var cutscene = null


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	cutscene_layer = CanvasLayer.new()
	RootManager.add_child_deff(cutscene_layer)
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


func summon_cutscene(cutscene_name) -> Node:
	cutscene = summon(PathsDB.cutscenes[cutscene_name], cutscene_layer)
	summon_transition_screen(0.2)
	cutscene.hide()
	yield(get_tree().create_timer(0.5), "timeout")
	cutscene.show()
	return cutscene


func on_cutscene_finished(instance):
	emit_signal("cutscene_finished", cutscene)
	cutscene = null


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


func summon(path:String, parent:Node) -> Node:
	var ControlPS = load(path)
	var instance: Node = ControlPS.instance()
	parent.call_deferred("add_child", instance)
	connect_ui_instance(instance)
	return instance


func connect_ui_instance(instance:Node):
	instance.connect("finished", self, "on_ui_instance_finished")


func on_ui_instance_finished(instance:Node):
	print(instance)
	if instance == cutscene:
		on_cutscene_finished(instance)
	instance.call_deferred("queue_free")
