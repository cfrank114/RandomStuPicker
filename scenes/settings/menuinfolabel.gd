extends Label

var click_count := 0
const REQUIRED_CLICKS := 5

var is_counting := false


func _ready():
	self.mouse_filter=1

func _gui_input(event):
	print(event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		click_count += 1
		update_label_text()
		
		if click_count >= REQUIRED_CLICKS:
			is_counting = true
			get_tree().change_scene_to_packed(Globals.special_scene)
			click_count = 0

func update_label_text():
	print("Pressed %d/%d times" % [click_count, REQUIRED_CLICKS])
	
