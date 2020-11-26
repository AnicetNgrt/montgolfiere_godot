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
export(int) var tirade_index setget set_tirade_index


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
	text_node.text = tirades[value]
	if value == tirades.size() - 1:
		button_ok.show()
		button_next.hide()
	else:
		button_ok.hide()
		button_next.show()


func _on_ButtonOk_pressed():
	call_deferred("queue_free")


func _on_ButtonNext_pressed():
	set_tirade_index(tirade_index+1)
