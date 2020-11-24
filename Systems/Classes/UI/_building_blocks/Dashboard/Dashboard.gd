extends Control

signal finished(instance)

var artifacts_offset = 0
var clues_offset = 0

func _ready():
	refresh_buttons()
	if LevelLoader.current_level != null:
		$Clock.show()
		$Artifacts.show()
		$Clue.show()
		set_time_of_day(LevelLoader.current_level.region.time_of_day)
		
		refresh_clues()
		refresh_artifacts()
	else:
		$Clock.hide()
		$Artifacts.hide()
		$Clue.hide()
	


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


func refresh_clues():
	var clues:Array = ProgressManager.progress_db.clues
	if clues.size() == 0:
		$Clue/ClueSprite.hide()
		$Clue/PreviousClue.hide()
		$Clue/NextClue.hide()
		$Clue/NoClues.show()
	else:
		$Clue/ClueSprite.show()
		$Clue/ClueSprite.texture = clues[clues_offset].texture
		if clues_offset-1 >= 0:
			$Clue/PreviousClue.show()
		else:
			$Clue/PreviousClue.hide()
		if clues_offset+1 < clues.size():
			$Clue/NextClue.show()
		else:
			$Clue/NextClue.hide()


func refresh_artifacts():
	var artifacts:Array = ProgressManager.progress_db.artifacts
	if artifacts.size() == 0:
		$Artifacts/A1.hide()
		$Artifacts/A2.hide()
		$Artifacts/A3.hide()
		$Artifacts/A4.hide()
		$Artifacts/PreviousArtifact.hide()
		$Artifacts/NextArtifact.hide()
		$Artifacts/NoArtifacts.show()
	else:
		if artifacts_offset-1 >= 0:
			$Artifacts/PreviousArtifact.show()
		else:
			$Artifacts/PreviousArtifact.hide()
		if artifacts_offset+4 < artifacts.size():
			$Artifacts/NextArtifact.show()
		else:
			$Artifacts/NextArtifact.hide()
		if artifacts_offset+3 < artifacts.size():
			$Artifacts/A4.show()
			$Artifacts/A4.artifact = artifacts[artifacts_offset+3]
		else:
			$Artifacts/A4.hide()
		if artifacts_offset+2 < artifacts.size():
			$Artifacts/A3.show()
			$Artifacts/A3.artifact = artifacts[artifacts_offset+2]
		else:
			$Artifacts/A3.hide()
		if artifacts_offset+1 < artifacts.size():
			$Artifacts/A2.show()
			$Artifacts/A2.artifact = artifacts[artifacts_offset+1]
		else:
			$Artifacts/A2.hide()
		if artifacts_offset < artifacts.size():
			$Artifacts/A1.show()
			$Artifacts/A1.artifact = artifacts[artifacts_offset]
		else:
			$Artifacts/A1.hide()


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
