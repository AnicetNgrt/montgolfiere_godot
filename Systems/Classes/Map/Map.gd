tool
extends Level

export(AudioStream) var theme

func _ready():
	if theme:
		MusicManager.stop_music()
		MusicManager.play_music(theme)
