extends CheckBox

func _ready() -> void:
	self.button_pressed=Globals.data["data"]["settings"]["allow_cp"]

func _toggled(toggled_on: bool) -> void:
	Globals.data["data"]["settings"]["allow_cp"]=toggled_on
