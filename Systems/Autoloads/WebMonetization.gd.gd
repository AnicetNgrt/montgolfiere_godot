extends Node


var _paying: bool
var _poll: Timer


func _ready() -> void:
	if JavaScript.eval("(document.monetization !== null);"):
		_poll = Timer.new()
		add_child(_poll)
		_poll.connect("timeout", self, "_on_poll_timeout")
		_poll.one_shot = false
		_poll.start(1)


func _on_poll_timeout() -> void:
	if JavaScript.eval("(document.monetization.state === 'started');"):
		if not _paying:
			_paying = true
			#_poll.queue_free()
	elif _paying:
		_paying = false


func is_paying() -> bool:
	return _paying
