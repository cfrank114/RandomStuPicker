extends ItemList

func _ready():
	var max_res = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	for i in Globals.res.keys():
		if Globals.res[i].x<=max_res.x and Globals.res[i].y<=max_res.y:
			self.add_item(i)
	
