extends CheckButton

func _ready():
	self.button_pressed=Globals.data["data"]["settings"]["fullscreen"]
	
func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		for i in $"../../Res/ItemList".item_count:
			$"../../Res/ItemList".set_item_disabled(i, true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		for i in $"../../Res/ItemList".item_count:
			$"../../Res/ItemList".set_item_disabled(i, false)
	Globals.data["data"]["settings"]["fullscreen"]=toggled_on
