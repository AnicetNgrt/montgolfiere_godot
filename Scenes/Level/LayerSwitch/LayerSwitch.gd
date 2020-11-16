tool
extends Area2D

export(int) var layer_out setget set_layer_out

func set_layer_out(value):
	layer_out = value
	name = "["+str(value)+"] LayerSwitch"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LayerSwitch_body_exited(body):
	pass


func _on_LayerSwitch_body_entered(body):
	print(body.global_position.y)
	print(global_position.y)
	print("\n")
	if body is Character and body.velocity.y > 0 or body.global_position.y < global_position.y:
		var charac:Character = body
		charac.switch_layer(layer_out)
