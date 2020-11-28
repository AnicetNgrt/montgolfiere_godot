tool
extends VBoxContainer

onready var thumbnail_container = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer2
onready var thumbnail_node = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/Thumbnail
onready var title_node = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Title
onready var text_node = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/MarginContainer/Text
onready var button_next = $HBoxContainer/CenterContainer/ButtonNext
onready var button_ok = $HBoxContainer/CenterContainer/ButtonOk


export(Texture) var thumbnail setget set_thumbnail
export(String) var title setget set_title
export(Array, String) var tirades
export(float) var pitch_scale = 1
export(int) var tirade_index setget set_tirade_index
export(bool) var show_tail = true setget set_show_tail


var tirade_word_index = 0
var tirade_words = ""
var completed = false
var last_word_addition = OS.get_ticks_msec()


signal completed()


func _physics_process(delta):	
	if tirade_word_index < tirade_words.length():
		if OS.get_ticks_msec() - last_word_addition > 50:
			add_word()
			$Sfx.pitch_scale = rand_range(pitch_scale-0.025,pitch_scale+0.025)
			$Sfx.play()
	else:
		$Sfx.stop()


func on_interaction():
	if tirade_word_index < tirade_words.length():
		for i in range(tirade_word_index, tirade_words.length()):
			add_word()
	else:
		increment_tirade_index()


func add_word():
	last_word_addition = OS.get_ticks_msec()
	text_node.text += tirade_words[tirade_word_index] + ""
	tirade_word_index += 1


func increment_tirade_index():
	last_word_addition = 0
	if tirade_index == tirades.size() - 1:
		print("here")
		emit_signal("completed")
		completed = true
		return
	set_tirade_index(tirade_index+1)


func set_thumbnail(value):
	if not is_inside_tree():
		yield(self, "ready")
	if value == null:
		thumbnail_container.hide()
	else:
		thumbnail_container.show()
	thumbnail = value
	thumbnail_node.texture = thumbnail


func set_title(value):
	if not is_inside_tree():
		yield(self, "ready")
	title = value
	title_node.text = title


func set_tirade_index(value):
	if value >= tirades.size() or value < 0:
		return
	if not is_inside_tree():
		yield(self, "ready")
	
	tirade_index = value
	text_node.text = ""
	tirade_word_index = 0
	tirade_words = tirades[tirade_index]
	
	if value >= tirades.size():
		completed = true
		emit_signal("completed")


func set_show_tail(value):
	show_tail = value
	if not is_inside_tree(): 
		yield(self, "ready")
	$HBoxContainer/Tail.visible = show_tail
