extends ScrollContainer

signal slot_chosen(slot)
var slot_count = 0

func _ready():
	refresh_slots()

func refresh_slots():
	for c in $MarginContainer/VBoxContainer.get_children():
		if c.name != "Button" and c.name != "Slot":
			c.call_deferred("queue_free")
	slot_count = 0
	
	var slots = ProgressManager.get_available_saveslots()
	for s in slots:
		add_slot(s)
	if slot_count < 9:
		$MarginContainer/VBoxContainer/Button.show()


func add_slot(slot:SaveSlot):
	var component = $MarginContainer/VBoxContainer/Slot.duplicate()
	component.save_slot = slot
	component.show()
	component.connect("chosen", self, "on_slot_chosen")
	$MarginContainer/VBoxContainer.add_child(component)
	slot_count += 1
	if slot_count >= 9:
		$MarginContainer/VBoxContainer/Button.hide()


func _on_Button_pressed():
	var slot = SaveSlot.new()
	slot.name = "Saved game #1"
	var slots = ProgressManager.get_available_saveslots()
	var names = []
	for s in slots:
		names.append(s.name)
	var i = 2
	while slot.name in names:
		slot.name = "Saved game #"+str(i)
		i += 1
	slot.save()
	refresh_slots()


func on_slot_chosen(instance):
	emit_signal("slot_chosen", instance.save_slot)
	ProgressManager.load_slot(instance.save_slot)
	self.call_deferred("queue_free")
