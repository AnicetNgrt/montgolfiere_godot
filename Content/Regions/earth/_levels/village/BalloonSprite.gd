tool
extends Sprite

func _ready():
	on_skin_changed(ProgressManager.progress_db.balloon_skin)
	ProgressManager.connect("balloon_skin_changed", self, "on_skin_changed")


func on_skin_changed(skin:BalloonSkin):
	texture = skin.side
