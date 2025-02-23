extends TextureButton

@onready var card = preload("res://scenes/card/card.tscn")
#@onready var type = ["gold","purple"]
@onready var card_list = []
func _process(delta):
	var dest=(self.position+self.size/2)
	Globals.dest_scale=Vector2(1,1)*(self.position.y/3000)
	dest.y*=0.5
	Globals.dest=dest
	if len(card_list)>2:
		var c = card_list[0]
		if c.finished and card_list[1].finished:
			get_tree().root.remove_child(c)
			card_list.pop_front()

func _pressed() -> void:
	if not Globals.need_shuffle:
		print("Creating new card at "+str(self.position+self.size/2))
		var c = card.instantiate()
		get_tree().root.add_child(c)
		c.set_card(Globals.card_number[Globals.ind],Globals.card_type[Globals.ind],Globals.data["data"]["settings"]["allow_cards"])
		if(Globals.data["data"]["settings"]["allow_cards"]):
			c.set_pos(self.position+self.size/2)
		else:
			var tmp = card_list.pop_front()
			get_tree().root.remove_child(tmp)
			c.set_pos(Globals.dest,false)
		card_list.append(c)
		Globals.history.append(Globals.card_number[Globals.ind])
		Globals.ind+=1
	if(Globals.ind >= Globals.total):
		print("Need reshuffling")
		Globals.need_shuffle=true
		if(Globals.data["data"]["settings"]["auto_erase_history"]):
			while Globals.history.size()>Globals.total:
				Globals.history.pop_front()
		Globals.ind=0
	
