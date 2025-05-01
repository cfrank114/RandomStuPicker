extends HBoxContainer



func _on_item_list_item_selected(index: int) -> void:
	if Globals.data["data"]["settings"]["fullscreen"]:return
	Globals.data["data"]["settings"]["res"]=$ItemList.get_item_text(index)
	Globals.change_res(Globals.res[$ItemList.get_item_text(index)])

func _ready():
	self.visible=OS.get_name() not in ["Android","iOS"]
