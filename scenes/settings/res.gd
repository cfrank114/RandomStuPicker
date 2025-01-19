extends HBoxContainer



func _on_item_list_item_selected(index: int) -> void:
	if Globals.data["data"]["settings"]["fullscreen"]:return
	get_window().size=Globals.res.values()[index]
	Globals.data["data"]["settings"]["res"]=Globals.res.keys()[index]
	get_window().position=Vector2i(100,200)
