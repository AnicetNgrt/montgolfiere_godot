tool
extends Node2D

export(Resource) var artifact setget set_artifact
var face = "A"
var last_swap = OS.get_ticks_msec()
var swap_cooldown = 500

func set_artifact(val):
	artifact = val
	if not is_inside_tree(): yield(self, "ready")
	if val is Artifact:
		$FaceA/Frame.texture = artifact.frame
		$FaceA/Painting.texture = artifact.background
		$FaceA/Object.texture = artifact.object
		hide_all_directions()
		match artifact.direction:
			Artifact.Directions.NORTH:
				$FaceB/NORTH.show()
			Artifact.Directions.SOUTH:
				$FaceB/SOUTH.show()
			Artifact.Directions.WEST:
				$FaceB/WEST.show()
			Artifact.Directions.EAST:
				$FaceB/EAST.show()
			Artifact.Directions.S_EAST:
				$FaceB/S_EAST.show()
			Artifact.Directions.S_WEST:
				$FaceB/S_WEST.show()
			Artifact.Directions.N_EAST:
				$FaceB/N_EAST.show()
			Artifact.Directions.N_WEST:
				$FaceB/N_WEST.show()
	else:
		$FaceA/Frame.texture = null
		$FaceA/Painting.texture = null
		$FaceA/Object.texture = null

func hide_all_directions():
	$FaceB/NORTH.hide()
	$FaceB/SOUTH.hide()
	$FaceB/WEST.hide()
	$FaceB/EAST.hide()
	$FaceB/N_EAST.hide()
	$FaceB/N_WEST.hide()
	$FaceB/S_EAST.hide()
	$FaceB/S_WEST.hide()

func change_to_face_A():
	if face == "B": $AnimationPlayer.play_backwards("toFaceB")
	face = "A"

func change_to_face_B():
	if face == "A": $AnimationPlayer.play("toFaceB")
	face = "B"


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if OS.get_ticks_msec() - last_swap > swap_cooldown:
			last_swap = OS.get_ticks_msec()
			if face == "B":
				change_to_face_A()
			else: 
				change_to_face_B()
