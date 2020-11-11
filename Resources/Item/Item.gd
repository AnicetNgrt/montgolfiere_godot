extends Resource

export(String) var nom
export(Texture) var texture_au_sol setget set_texture_au_sol

func set_texture_au_sol(value):
	texture_au_sol = value
	emit_signal("texture_au_sol_changed", texture_au_sol)

signal texture_au_sol_changed(texture_au_sol)
