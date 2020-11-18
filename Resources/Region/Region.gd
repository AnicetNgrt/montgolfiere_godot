class_name Region
extends Resource

export(Texture) var map_icon
export(String) var map_name
export(Environment) var environment = preload("res://Resources/Environment/default.tres")
export(Resource) var physics_profile = preload("res://Resources/CharacterPhysicsProfile/default_physics_profile.tres")#: CharacterPhysicsProfile
export(Resource) var day_night_anim = preload("res://Resources/Animations/day_night_regular.tres")

var discovered := false
var is_inside := false
var characState: CharacterState
var checkpoint: SpawnPoint
var time_of_day: float
