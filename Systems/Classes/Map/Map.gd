tool
extends Level

export(AudioStream) var theme

func _ready():
	if theme:
		MusicManager.stop_music()
		MusicManager.play_music(theme)


func _on_ThanksForPlaying_body_entered(body):
	UiSummoner.summon_region_title("Thanks for playing!")
