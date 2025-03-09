extends CheckButton

func _ready():
	self.button_pressed=Globals.data["data"]["settings"]["allow_glow_effect"]
	
func _toggled(toggled_on: bool) -> void:
	Globals.data["data"]["settings"]["allow_glow_effect"]=toggled_on
