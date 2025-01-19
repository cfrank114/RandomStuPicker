extends SpinBox

func _ready():
	self.value=int(Globals.data["data"]["settings"]["range"][0])
	Globals.settings_changed=false

func _value_changed(new_value: float) -> void:
	if(new_value>0 and new_value<Globals.data["data"]["settings"]["range"][1]):
		Globals.data["data"]["settings"]["range"][0]=self.value
		Globals.settings_changed=true
	else:
		self.value=Globals.data["data"]["settings"]["range"][0]
	
