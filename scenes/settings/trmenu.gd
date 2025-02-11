extends OptionButton

func _ready():
	for i in Globals.lang:
		self.add_item(i)
	self.selected=Globals.lang.find(Globals.data["data"]["settings"]["lang"])

func _on_item_selected(index: int) -> void:
	Globals.data["data"]["settings"]["lang"]=Globals.lang[index]
	TranslationServer.set_locale(Globals.lang[index])
	$"../../../../../..".translate()
