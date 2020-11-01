extends AudioStreamPlayer

func _ready():
	connect("finished", self, "on_finished")

func on_finished():
	play()
