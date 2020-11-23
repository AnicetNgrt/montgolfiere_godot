class_name SaveSlot
extends Resource

export(String) var name
export(Dictionary) var created_at = OS.get_datetime()
export(Dictionary) var last_modified = OS.get_datetime()
export(Resource) var progress_db


func save():
	var file = File.new()
	file.open("user://earthsecrets-"+self.name+".saveslot.json", File.WRITE)
	
	var data = {
		"name": name,
		"created_at": created_at,
		"last_modified": OS.get_datetime(),
		"progress_db": progress_db.to_dict()
	}
	
	var json = JSON.print(data, "  ", true)
	
	file.store_string(json)
	file.close()


func load_from_file(path:String):
	var file = File.new()
	file.open(path, File.READ)
	
	var json = file.get_as_text()
	var data = JSON.parse(json)
	name = data["name"]
	created_at = data["created_at"]
	last_modified = data["last_modified"]
	progress_db = data["progress_db"]
	
	file.close()
