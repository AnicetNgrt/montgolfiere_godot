extends Node

signal finished(instance)

func _ready():
	$Texts/Disclaimer.show()


func _on_PoemContinueButton_pressed():
	$Animation.play()


func _on_ContinueToPoemButton_pressed():
	$Animation.play("Main")
	$Animation.seek(0)
	$Animation.stop()
	TweensUtils.fadeout($Texts/Disclaimer, 0.5)
	yield(get_tree().create_timer(0.5), "timeout")
	$Texts/Disclaimer.hide()


func _on_ButtonFinish_pressed():
	print("here")
	ProgressManager.progress_db.saw_intro_cutscene = true
	ProgressManager.save()
	emit_signal("finished", self)


func _on_SkipButton_pressed():
	_on_ButtonFinish_pressed()


func _on_ColorRect2_mouse_entered():
	#$SkipButton.show()
	pass


func _on_ColorRect2_mouse_exited():
	#$SkipButton.hide()
	pass


func _on_SkipButton_mouse_entered():
	#$SkipButton.show()
	pass
