extends VBoxContainer

var check_boxes = []

func add_option(text,enabled,index):
	var hbox = HBoxContainer.new()
	add_child(hbox)  
	var label = Label.new()
	label.name="option"
	label.text = text
	hbox.add_child(label)
	var check_box = CheckBox.new()
	check_box.button_pressed=enabled
	check_box.toggled.connect(Callable(self, "_on_check_box_toggled").bind(index-1))
	check_boxes.append(check_box)
	hbox.add_child(check_box)
	

func _on_check_box_toggled(state,index):
	var check_box = check_boxes[index]
	if state:
		Globals.data["data"]["settings"]["except"].append(float(index+1))
	else:
		Globals.data["data"]["settings"]["except"].pop_at(Globals.data["data"]["settings"]["except"].find(float(index+1)))
	Globals.data["data"]["settings"]["except"].sort()
	Globals.calculate_total()
	Globals.need_shuffle=true
	print(Globals.data["data"]["settings"]["except"])

func upd():
	for i in get_children():
		check_boxes.pop_front()
		self.remove_child(i)
	print(Globals.data["data"]["settings"]["except"])
	for i in range(Globals.data["data"]["settings"]["range"][0],Globals.data["data"]["settings"]["range"][1]+1):
		add_option(str(i),Globals.data["data"]["settings"]["except"].has(float(i)),i)


func _ready():
	upd()
