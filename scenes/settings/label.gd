extends Label


func _process(delta):
	if Globals.settings_changed:
		self.text="改动将在重启软件后实行"
	else:
		self.text=""
