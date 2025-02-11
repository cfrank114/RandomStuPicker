extends VBoxContainer

var check_boxes = []

func add_option(text,enabled):
	var hbox = HBoxContainer.new()
	add_child(hbox)  
	var label = Label.new()
	label.name="option"
	label.text = text
	hbox.add_child(label)
	var check_box = CheckBox.new()
	check_box.button_pressed=enabled
	check_box.toggled.connect(Callable(self, "_on_check_box_toggled").bind(check_boxes.size()))
	check_boxes.append(check_box)
	hbox.add_child(check_box)
	

func _on_check_box_toggled(state,index):
	var check_box = check_boxes[index]
	if state:
		Globals.data["data"]["settings"]["except"].append(index+1)
	else:
		Globals.data["data"]["settings"]["except"].pop_at(Globals.data["data"]["settings"]["except"].find(index+1))
	Globals.data["data"]["settings"]["except"].sort()
	Globals.settings_changed=true


func _ready():
	for i in range(Globals.data["data"]["settings"]["range"][0],Globals.data["data"]["settings"]["range"][1]+1):
		add_option(str(i),Globals.data["data"]["settings"]["except"].has(float(i)))
