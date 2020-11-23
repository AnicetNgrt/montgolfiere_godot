tool
extends PanelContainer

onready var name_tag = $MarginContainer/HBoxContainer/VBoxContainer/Name
onready var created_at_tag = $MarginContainer/HBoxContainer/VBoxContainer/CreatedAt
onready var modified_tag = $MarginContainer/HBoxContainer/VBoxContainer/Modified

export(Resource) var save_slot setget set_slot

func set_slot(value):
	save_slot = value
	if not is_inside_tree(): yield(self, "ready")
	if value is SaveSlot:
		name_tag.text = value.name
		created_at_tag.text = "Created at: "+date_to_string(value.created_at)
		modified_tag.text = "Last modified: "+date_to_string(value.last_modified)

func date_to_string(date:Dictionary):
	return str(date["month"])+"/"+str(date["day"])+"/"+str(date["year"])+" "+str(date["hour"])+":"+str(date["minute"])
