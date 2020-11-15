tool
extends Node2D

export(Resource) var artifact setget set_artifact

func set_artifact(val):
	artifact = val
	if not is_inside_tree(): yield(self, "ready")
	if val is Artifact:
		$Frame.texture = artifact.frame
		$Painting.texture = artifact.background
		$Object.texture = artifact.object
	else:
		$Frame.texture = null
		$Painting.texture = null
		$Object.texture = null
