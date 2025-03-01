extends Button

func _pressed():
	var data = JSON.parse_string($"../CodeEdit".text)
	if data == null:
		self.text="error"
		return
	self.text="Parsed"
	Globals.data = data
	Globals.check_and_fix_data(Globals.data,Globals.data_template)
