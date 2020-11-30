tool
extends TextureRect

export(Resource) var balloon setget set_balloon


func set_balloon(value):
	balloon = value
	texture = value.top_down


func _ready():
	on_skin_changed(ProgressManager.progress_db.balloon_skin)
	ProgressManager.connect("balloon_skin_changed", self, "on_skin_changed")


func _on_BalloonButton_gui_input(event):
	if event is InputEventMouseButton:
		ProgressManager.set_balloon_skin(balloon)


func on_skin_changed(skin:BalloonSkin):
	if skin == balloon:
		modulate = Color.white
	else:
		modulate = Color(1, 1, 1, 0.5)
