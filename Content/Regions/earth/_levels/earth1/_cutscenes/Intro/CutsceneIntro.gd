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
	emit_signal("finished", self)
