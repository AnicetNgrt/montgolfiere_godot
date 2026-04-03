class_name WindZone
tool
extends Area2D

# Direction and magnitude of wind force applied to the player inside this zone.
# Positive x = rightward wind, positive y = downward wind.
export var wind_force := Vector2(40.0, 0.0)

# Duration (seconds) to lerp wind_direction in/out when entering or leaving.
export(float) var fade_duration := 0.4

var _bodies_inside := []


func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

	if Engine.editor_hint:
		return

	$WindAudio.volume_db = -80.0
	$WindAudio.play()


func _on_body_entered(body) -> void:
	if Engine.editor_hint:
		return
	if not body is PlatformerController:
		return
	_bodies_inside.append(body)
	_apply_wind(body, wind_force)
	_fade_audio(true)


func _on_body_exited(body) -> void:
	if Engine.editor_hint:
		return
	if not body is PlatformerController:
		return
	_bodies_inside.erase(body)
	_apply_wind(body, Vector2.ZERO)
	if _bodies_inside.empty():
		_fade_audio(false)


func _apply_wind(body: PlatformerController, target: Vector2) -> void:
	var tween := Tween.new()
	add_child(tween)
	tween.interpolate_property(
		body,
		"wind_direction",
		body.wind_direction,
		target,
		fade_duration,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tween.start()
	tween.connect("tween_all_completed", tween, "queue_free")


func _fade_audio(fade_in: bool) -> void:
	var tween := Tween.new()
	add_child(tween)
	var target_db := -10.0 if fade_in else -80.0
	tween.interpolate_property(
		$WindAudio,
		"volume_db",
		$WindAudio.volume_db,
		target_db,
		fade_duration,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tween.start()
	tween.connect("tween_all_completed", tween, "queue_free")
