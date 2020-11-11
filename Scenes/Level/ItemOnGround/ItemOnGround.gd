tool
extends Area2D

export(Resource) var item

func _ready():
	item.connect("texture_au_sol_changed", self, "on_item_texture_au_sol_changed")
	$Sprite.texture = item.texture_au_sol

func on_item_texture_au_sol_changed(texture):
	$Sprite.texture = texture

func _on_ItemOnGround_body_entered(body):
	if body is Character:
		pass
