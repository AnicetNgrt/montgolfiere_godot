extends Node

func _ready():
	$Texts/Disclaimer.show()
	OS.window_fullscreen = true


func _on_PoemContinueButton_pressed():
	$Animation.play()


func _on_ContinueToPoemButton_pressed():
	$Animation.play("Main")
	$Animation.seek(0)
	$Animation.stop()
	TweensUtils.fadeout($Texts/Disclaimer, 0.5)
	yield(get_tree().create_timer(0.5), "timeout")
	$Texts/Disclaimer.hide()
