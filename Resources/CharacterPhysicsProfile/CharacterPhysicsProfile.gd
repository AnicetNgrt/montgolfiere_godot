class_name CharacterPhysicsProfile
extends Resource

export (int) var max_speed_walking := 0
export (int) var max_speed_running := 0
export (int) var jump_speed := 0
export (int) var gravity := 0
export (float, 0, 1.0) var friction_floor = 0.2
export (float, 0, 1.0) var friction_air = 0.01
export (float, 0, 1.0) var acceleration_walking = 0.25
export (float, 0, 1.0) var acceleration_running = 0.5
