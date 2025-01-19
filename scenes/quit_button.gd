extends TextureButton

func _pressed() -> void:
	#TODO:remove when release
	var json = JSON.new()
	var temp_data = json.stringify(Globals.data)
	Globals.data_file.resize(0)
	Globals.data_file.store_string(temp_data)
	Globals.data_file.close()
	get_tree().quit()
