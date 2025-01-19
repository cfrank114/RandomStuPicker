extends SpinBox

func _ready():
	self.value=int(Globals.data["data"]["settings"]["range"][1])

func _value_changed(new_value: float) -> void:
	if(new_value<100 and new_value>Globals.data["data"]["settings"]["range"][0]):
		Globals.data["data"]["settings"]["range"][1]=int(self.value)
	else:
		self.value=Globals.data["data"]["settings"]["range"][1]
	
