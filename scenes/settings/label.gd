extends Label


func _process(delta):
	if Globals.total<=1:
		self.text=tr("Warning")+":"+tr("Menu_Settings_Total_Zero")
	else:
		self.text=""
