tool
extends Area2D

export(String) var unique_name
export(bool) var repeat_after_complete = false
var _body: PlatformerController = null


func _input(event):
	if Input.is_action_just_pressed("interact") and $CanvasLayer/Dialogue.visible:
		$CanvasLayer/Dialogue.on_interaction()


func _on_ZoneDialogue_body_entered(body):
	if ProgressManager.progress_db.dialogues.get(unique_name) == true:
		$CanvasLayer/Dialogue.completed = true
	
	$CanvasLayer/Dialogue.rect_global_position = $Offset.global_position + Vector2(-(230+($CanvasLayer/Dialogue.rect_size.x/2)),-(280+$CanvasLayer/Dialogue.rect_size.y))
	if ProgressManager.progress_db.dialogues.get(unique_name, null) == true:
		$CanvasLayer/Dialogue.completed = true
	
	if !repeat_after_complete and $CanvasLayer/Dialogue.completed:
		return
	elif body is PlatformerController:
		print("LOCK")
		_body = body
		_body.locked = true
	
	$CanvasLayer/Dialogue.tirade_index = 0
	TweensUtils.fadein($CanvasLayer/Dialogue, 0.5)
	$CanvasLayer/Dialogue.show()
	$CanvasLayer/Dialogue.unmute()


func _on_ZoneDialogue_body_exited(body):
	if body is PlatformerController:
		print("YARE")
		body.locked = false
		_body = null
	
	TweensUtils.fadeout($CanvasLayer/Dialogue, 0.5)
	$CanvasLayer/Dialogue.mute()
	yield(get_tree().create_timer(0.5), "timeout")
	$CanvasLayer/Dialogue.hide()


func _on_Dialogue_completed():
	if _body != null:
		print("HERE")
		_body.locked = false
		_body = null
	
	ProgressManager.progress_db.dialogues[unique_name] = true
	TweensUtils.fadeout($CanvasLayer/Dialogue, 0.5)
	$CanvasLayer/Dialogue.mute()
	yield(get_tree().create_timer(0.5), "timeout")
	$CanvasLayer/Dialogue.hide()
