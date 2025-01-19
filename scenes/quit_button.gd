extends TextureButton

func _pressed() -> void:
	#TODO:remove when release
	Globals.save()
	get_tree().quit()
	
