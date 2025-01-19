extends Label

func _ready():
	self.text = "软件版本："+str(Globals.app_ver)+"\n数据包版本："+str(Globals.data["version"])
