extends CheckButton

func _ready():
	self.button_pressed=Globals.data["data"]["settings"]["allow_cards"]
	
func _toggled(toggled_on: bool) -> void:
	Globals.data["data"]["settings"]["allow_cards"]=toggled_on
