extends Node

func interpolate_property(node:Node, property:String, before, after, duration:float, trans, easing):
	if trans == null: trans = 1
	if easing == null: easing = 1
	
	var tween = Tween.new()
	tween.interpolate_property(
		node,
		property, 
		before, 
		after,
		duration,
		trans,
		easing)
	add_child(tween)
	tween.start()
	if tween.is_active(): yield(tween, "tween_completed")
	remove_child(tween)
	tween.call_deferred("queue_free")


func fadein(element:CanvasItem):
	self.interpolate_property(
		element, 
		"modulate", 
		Color(1,1,1,0), 
		Color(1,1,1,1),
		1, null, null)


func fadeout(element:CanvasItem):
	self.interpolate_property(
		element,
		"modulate", 
		Color(1,1,1,1), 
		Color(1,1,1,0),
		1, null, null)