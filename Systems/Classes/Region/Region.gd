class_name Region
extends Resource

export(Texture) var map_icon
export(String) var map_name
export(Environment) var environment
export(Resource) var physics_profile
export(Resource) var day_night_anim
export(AudioStream) var theme
export(float) var theme_volume

var clues = []
var discovered := false
var is_inside := false
var checkpoint
var time_of_day: float

var play_daylight_score = -1


signal play_daynight()
signal pause_daynight()


func pause_daynight():
	play_daylight_score -= 1
	if play_daylight_score < 0:
		emit_signal("pause_daynight")


func play_daynight():
	play_daylight_score += 1
	if play_daylight_score >= 0:
		emit_signal("play_daynight")
