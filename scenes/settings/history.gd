extends CheckButton

func _ready():
	self.button_pressed=Globals.data["data"]["settings"]["auto_erase_history"]
	
func _toggled(toggled_on: bool) -> void:
	Globals.data["data"]["settings"]["auto_erase_history"]=toggled_on
