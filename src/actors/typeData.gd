extends Node

var items := []
var types := {}

#@onready var file = preload("res://src/itemLookUp.json")

func _init():
	if not FileAccess.file_exists("res://src/itemLookUp.json"):
		print("missing itemLookUp.json")
		return
	var lookUpFile = FileAccess.open("res://src/itemLookUp.json", FileAccess.READ)

	var json = JSON.new()
	var error = json.parse(lookUpFile.get_as_text())
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			types = data_received.pop_back()
			items = data_received
#			print("data received")
		else:
			print("itemLookUp.gsm corrupted")
	else:
		print("JSON Parse Error: ", json.get_error_message()," at line ", json.get_error_line())

func saveItemsTable():
	items.append(types)
	var lookUpFile = FileAccess.open("res://src/itemLookUp.json", FileAccess.WRITE)
	var json_string = JSON.stringify(items,"\t")
	lookUpFile.store_line(json_string)
	print("saved")
