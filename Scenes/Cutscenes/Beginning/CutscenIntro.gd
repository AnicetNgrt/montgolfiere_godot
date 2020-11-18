extends Node

func _ready():
	OS.window_fullscreen = true


func _on_PoemContinueButton_pressed():
	$Animation.play("Main")


func _on_ContinueToPoemButton_pressed():
	TweensUtils.fadeout($Texts/Disclaimer)
	yield(get_tree().create_timer(1), "timeout")
	$Texts/Disclaimer.hide()
	TweensUtils.fadein($Texts/Poem)
