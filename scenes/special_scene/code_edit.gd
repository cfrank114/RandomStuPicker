extends CodeEdit

func _ready():
	self.text = JSON.stringify(Globals.data)
	
