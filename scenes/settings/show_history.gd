extends RichTextLabel

func _process(delta: float) -> void:
	self.text=""
	
	if(len(Globals.history)==0):
		self.push_font_size(48)
		self.append_text("[center]"+tr("Menu_History_None")+"[/center]")
		return
	self.push_font_size(40)
	for i in range(len(Globals.history),0,-1):
		self.append_text("[center]"+str(Globals.history[i-1])+",[/center]\n")
	
