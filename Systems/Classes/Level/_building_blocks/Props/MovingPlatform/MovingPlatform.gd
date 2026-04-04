tool
class_name MovingPlatform
extends StaticBody2D

export(Vector2) var travel = Vector2(200.0, 0.0)
export(float) var speed = 80.0
export(float) var pause_duration = 0.3

var _origin: Vector2
var _t: float = 0.0
var _direction: int = 1
var _pausing: float = 0.0


func _ready() -> void:
	_origin = position


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _pausing > 0.0:
		_pausing -= delta
		constant_linear_velocity = Vector2.ZERO
		return

	var travel_length := travel.length()
	if travel_length < 1.0:
		return

	var step := (speed / travel_length) * delta
	_t += step * float(_direction)

	if _t >= 1.0:
		_t = 1.0
		_direction = -1
		_pausing = pause_duration
	elif _t <= 0.0:
		_t = 0.0
		_direction = 1
		_pausing = pause_duration

	var new_pos := _origin + travel * _t
	constant_linear_velocity = (new_pos - position) / delta
	position = new_pos
