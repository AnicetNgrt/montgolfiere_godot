class_name BouncePad
extends Area2D

# How hard the player is launched upward (px/s).
# Default 1100 is noticeably stronger than the normal jump_speed of 800.
export var bounce_force := 1100.0

# Multiplier applied to horizontal velocity on bounce.
# 1.0 preserves momentum; <1.0 dampens it for vertical-only launches.
export var horizontal_damping := 0.7

var _tween: Tween
var _on_cooldown := false


func _ready() -> void:
	_tween = Tween.new()
	add_child(_tween)
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node) -> void:
	if _on_cooldown:
		return
	if not body is PlatformerController:
		return
	if body.velocity.y > 50:
		body.velocity.y = -bounce_force
		body.velocity.x *= horizontal_damping
		_play_squish()


func _play_squish() -> void:
	_on_cooldown = true
	$Visual.scale = Vector2(1.2, 0.55)
	_tween.stop_all()
	_tween.interpolate_property(
		$Visual,
		"scale",
		Vector2(1.2, 0.55),
		Vector2(1.0, 1.0),
		0.45,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_on_cooldown = false
