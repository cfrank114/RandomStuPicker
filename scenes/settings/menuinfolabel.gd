extends Label

# 定义点击次数和目标点击次数
var click_count := 0
const REQUIRED_CLICKS := 5

# 标记是否正在计数，防止多次触发
var is_counting := false

# 目标场景路径（请根据实际情况修改）
const TARGET_SCENE := "res://scenes/special_scene/special.tscn"

func _ready():
	self.mouse_filter=1

func _gui_input(event):
	print(event)
	# 只处理鼠标左键点击事件
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		click_count += 1
		update_label_text()
		
		if click_count >= REQUIRED_CLICKS:
			is_counting = true
			switch_scene()
			click_count = 0  # 重置点击计数

func update_label_text():
	print("已点击 %d/%d 次" % [click_count, REQUIRED_CLICKS])

func switch_scene():
	get_tree().change_scene_to_file(TARGET_SCENE)
