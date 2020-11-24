extends Control


signal finished(instance)


func _ready():
	refresh_buttons()


func refresh_buttons():
	if AudioServer.is_bus_mute(1):
		$Menu/ButtonSounds.text = "Sounds: OFF"
	else:
		$Menu/ButtonSounds.text = "Sounds: ON"
	if AudioServer.is_bus_mute(2):
		$Menu/ButtonMusic.text = "Music: OFF"
	else:
		$Menu/ButtonMusic.text = "Music: ON"
	if OS.window_fullscreen:
		$Menu/ButtonFullscreen.text = "Fullscreen: ON"
	else:
		$Menu/ButtonFullscreen.text = "Fullscreen: OFF"


func _on_ButtonMusic_pressed():
	AudioServer.set_bus_mute(2, !AudioServer.is_bus_mute(2))
	refresh_buttons()


func _on_ButtonSounds_pressed():
	AudioServer.set_bus_mute(1, !AudioServer.is_bus_mute(1))
	refresh_buttons()


func _on_ButtonFullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	refresh_buttons()


func _on_ButtonQuit_pressed():
	get_tree().quit()


func _on_ButtonAbout_pressed():
	$Credits.show()


func _on_Saves_slot_chosen(slot):
	UiSummoner.summon_transition_screen(0.2)
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("queue_free")
