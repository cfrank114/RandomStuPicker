extends TextureButton

var CardScene = preload("res://scenes/card/card.tscn")
var card_list: Array = []
var layer_list: Array = []

func _ready() -> void:
	_update_dest_position()

func _update_dest_position() -> void:
	var dest = position + size / 2
	Globals.dest_scale = Vector2.ONE * (position.y / 3000)
	dest.y *= 0.5
	Globals.dest = dest

func _process(delta: float) -> void:
	# 仅当有足够卡牌时才执行清理
	if card_list.size() > 2:
		_cleanup_oldest_card()

func _cleanup_oldest_card() -> void:
	var oldest_layer = layer_list[0]
	var oldest_card = card_list[0]
	
	if oldest_card.finished and card_list[1].finished:
		# 安全移除节点
		oldest_layer.queue_free()
		
		card_list.pop_front()
		layer_list.pop_front()
		
		# 更新顶部卡牌层级
		if layer_list.size() > 0:
			layer_list[0].layer = 1

func create_card() -> void:
	if Globals.need_shuffle:
		return
	
	var new_layer = CanvasLayer.new()
	new_layer.layer = 2
	$"../../Cards".add_child(new_layer)
	
	var new_card = CardScene.instantiate()
	new_layer.add_child(new_card)
	
	var is_special = (
		Globals.ind < Globals.total - Globals.step and
		float(Globals.card_number[Globals.ind + Globals.step]) in Globals.data["data"]["constants"]["special"]
	)
	
	new_card.set_card(
		Globals.card_number[Globals.ind],
		Globals.card_type[Globals.ind],
		true,
		Globals.data["data"]["settings"]["allow_cards"],
		is_special
	)
	
	if Globals.data["data"]["settings"]["allow_cards"]:
		new_card.set_pos(position + size / 2)
	else:
		new_card.set_pos(Globals.dest, false)
		_remove_first_card()
	
	card_list.append(new_card)
	layer_list.append(new_layer)
	Globals.history.append(Globals.card_number[Globals.ind])
	Globals.ind += 1
	
	if Globals.ind >= Globals.total-1:
		Globals.need_shuffle = true
		if Globals.data["data"]["settings"]["auto_erase_history"]:
			while Globals.history.size() > Globals.total:
				Globals.history.pop_front()
		Globals.ind=0

func _remove_first_card() -> void:
	if layer_list.size() == 0:
		return
	
	var first_layer = layer_list[0]
	first_layer.queue_free()
	
	card_list.pop_front()
	layer_list.pop_front()

func _pressed() -> void:
	create_card()
