extends Control

signal finished(instance)


func _ready():
	if LevelLoader.current_level != null:
		set_time_of_day(LevelLoader.current_level.region.time_of_day)
	

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

func set_time_of_day(tod:float):
	if not is_inside_tree(): yield(self, "ready")
	var minutes_day = 1440*tod
	var minutes = int(minutes_day) % 60
	var hours = floor(int(minutes_day) / 60)
	var s_minutes = str(minutes)
	if minutes < 10:
		s_minutes = "0"+s_minutes
	var s_hours = str(hours)
	if hours < 10:
		s_hours = "0"+s_hours
	$Clock/Time.text = s_hours+":"+s_minutes


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


func _on_ButtonHideCredits_pressed():
	$Credits.hide()


func _on_ButtonAbout_pressed():
	$Credits.show()
