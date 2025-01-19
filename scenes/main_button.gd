extends TextureButton

@onready var card = preload("res://scenes/card/card.tscn")
#@onready var type = ["gold","purple"]
@onready var card_list = []
@onready var ind = 0
func _process(delta):
	var dest=(self.position+self.size/2)
	Globals.dest_scale=Vector2(1,1)*(self.position.y/3000)
	dest.y*=0.5
	Globals.dest=dest
	if len(card_list)>2:
		var c = card_list.pop_front()
		if c.finished:get_tree().root.remove_child(c)

func _pressed() -> void:
	if not Globals.need_shuffle:
		var c = card.instantiate()
		get_tree().root.add_child(c)
		c.set_card(Globals.card_number[ind],Globals.card_type[ind])
		c.set_pos(self.position+self.size/2)
		card_list.append(c)
		ind+=1
	if(ind >= Globals.total):
		Globals.need_shuffle=true
		ind=0
	
