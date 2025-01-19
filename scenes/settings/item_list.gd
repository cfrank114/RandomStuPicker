extends ItemList

func _ready():
	for i in Globals.res.keys():
		self.add_item(i)
	
