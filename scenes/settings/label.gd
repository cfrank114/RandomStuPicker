extends Label


func _process(delta):
	if Globals.settings_changed:
		self.text=tr("Menu_Settings_Changed")
	else:
		self.text=""
