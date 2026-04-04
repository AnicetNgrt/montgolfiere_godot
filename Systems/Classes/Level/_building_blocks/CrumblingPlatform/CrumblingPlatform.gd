class_name CrumblingPlatform
extends StaticBody2D

# Seconds the player must stand before crumbling starts
export var crumble_delay := 0.8
# Seconds the platform stays fallen before respawning
export var respawn_delay := 3.0

enum State { IDLE, SHAKING, FALLEN }
var _state = State.IDLE
var _tween: Tween

onready var _collision: CollisionShape2D = $CollisionShape2D
onready var _visual: Node2D = $Visual
onready var _detector: Area2D = $Detector
onready var _crumble_timer: Timer = $CrumbleTimer
onready var _respawn_timer: Timer = $RespawnTimer


func _ready():
	_tween = Tween.new()
	add_child(_tween)


func _on_body_entered(body: Node):
	if body is PlatformerController and _state == State.IDLE:
		_crumble_timer.start(crumble_delay)


func _on_body_exited(body: Node):
	if body is PlatformerController and _state == State.IDLE:
		_crumble_timer.stop()


func _on_crumble_timeout():
	if _state == State.IDLE:
		_state = State.SHAKING
		_shake()


func _shake():
	var s := 5.0
	_tween.stop_all()
	_tween.interpolate_property(
		_visual, "position",
		Vector2.ZERO, Vector2(s, 0),
		0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	_tween.interpolate_property(
		_visual, "position",
		Vector2(s, 0), Vector2(-s, 0),
		0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.05
	)
	_tween.interpolate_property(
		_visual, "position",
		Vector2(-s, 0), Vector2(s, 0),
		0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.10
	)
	_tween.interpolate_property(
		_visual, "position",
		Vector2(s, 0), Vector2.ZERO,
		0.05, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.15
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_fall()


func _fall():
	_state = State.FALLEN
	_collision.set_deferred("disabled", true)
	_tween.stop_all()
	_tween.interpolate_property(
		_visual, "position",
		Vector2.ZERO, Vector2(0, 150),
		0.3, Tween.TRANS_QUAD, Tween.EASE_IN
	)
	_tween.interpolate_property(
		_visual, "modulate:a",
		1.0, 0.0,
		0.3, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_respawn_timer.start(respawn_delay)


func _on_respawn_timeout():
	_visual.position = Vector2.ZERO
	var m = _visual.modulate
	m.a = 0.0
	_visual.modulate = m
	_collision.set_deferred("disabled", false)
	_tween.stop_all()
	_tween.interpolate_property(
		_visual, "modulate:a",
		0.0, 1.0,
		0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	_tween.start()
	yield(_tween, "tween_all_completed")
	_state = State.IDLE
