class_name CharacterState
extends Resource

export(float) var stamina = 100
export(float) var max_stamina = 100
export(Array, Resource) var inventory = []
export(Array, Resource) var known_recipes = []
export(String) var respawn_point
export (float) var walk_stamina_loss_mult = 2
export (float) var run_stamina_loss_mult = 10
export (float) var jump_stamina_loss = 2
export (float) var jump_run_stamina_loss = 10
export (float) var climb_stamina_loss = 5
