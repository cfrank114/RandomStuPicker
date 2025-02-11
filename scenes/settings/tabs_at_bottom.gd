extends CheckButton

func _ready():
	self.button_pressed=Globals.data["data"]["settings"]["tab_at_bottom"]
	
func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"../../../../..".tabs_position=TabContainer.POSITION_BOTTOM
	else:
		$"../../../../..".tabs_position=TabContainer.POSITION_TOP
	Globals.data["data"]["settings"]["tab_at_bottom"]=toggled_on
