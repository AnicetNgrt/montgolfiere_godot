class_name Artifact
extends Resource

enum Directions {
	NORTH, EAST, SOUTH, WEST, S_WEST, S_EAST, N_WEST, N_EAST
}

export(Texture) var frame
export(Texture) var object
export(Texture) var background
export(Directions) var direction = Directions.NORTH
