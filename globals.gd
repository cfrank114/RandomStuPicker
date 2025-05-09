extends Node

const data_template = {
	"data":{
		"constants":{
			"cp":{
				"10":[43,48],
				"15":[39],
				"17":[48],
				"19":[37],
				"22":[45],
				"33":[38,44],
				"4":[46],
				"7":[40,49]
				},
			"special":[12]
			},
		"settings":{
			"allow_cards":true,
			"allow_cp":false,
			"allow_glow_effect":true,
			"auto_erase_history":true,
			"background":null,
			"except":[6,32,42],
			"fullscreen":true,
			"lang":"en_US",
			"range":[1,49],
			"res":"1920x1080",
			"tab_at_bottom":false,
			}
		},
	"version":"1.3-alpha2"
}

const uni_pass="cgfirbabnekroiosfh7497sm182938114514"

const number_color={
	"normal":Vector4(143,143,143,255),
	"gold":Vector4(205,176,0,255),
	"purple":Vector4(122,111,238,255),
	"blue":Vector4(74,194,183,255),
	"pink":Vector4(255,129,129,255)
	}
	
const glow_color={
	"normal":Vector4(0,0,0,255),
	"gold":Vector4(160,79,141,255),
	"purple":Vector4(187,102,213,255),
	"blue":Vector4(130,146,192,255),
	"pink":Vector4(195,63,123,255)
	}
	
const res = {
	# 超宽屏/带鱼屏
	"5120x1440": Vector2(5120, 1440),  # 32:9 超宽屏
	"3440x1440": Vector2(3440, 1440),  # 21:9 带鱼屏
	"2560x1080": Vector2(2560, 1080),  # 21:9 入门带鱼屏
	
	# 16:9 标准比例
	"7680x4320": Vector2(7680, 4320),  # 8K
	"3840x2160": Vector2(3840, 2160),  # 4K
	"2560x1440": Vector2(2560, 1440),  # 2K/QHD
	"1920x1080": Vector2(1920, 1080),  # FHD
	"1600x900": Vector2(1600, 900),
	"1366x768": Vector2(1366, 768),    # 笔记本常见
	"1280x720": Vector2(1280, 720),    # HD
	
	# 16:10 生产力比例
	"3840x2400": Vector2(3840, 2400),  # Surface Pro 9
	"2560x1600": Vector2(2560, 1600),
	"1920x1200": Vector2(1920, 1200),
	
	# 平板设备
	"2048x1536": Vector2(2048, 1536),  # iPad Pro 11寸
	"2388x1668": Vector2(2388, 1668),  # Surface Pro 8
	
	# 移动设备竖屏
	"1440x2560": Vector2(1440, 2560),  # 手机QHD竖屏
	"1080x1920": Vector2(1080, 1920),  # 手机FHD竖屏
	"720x1280": Vector2(720, 1280),    # 手机HD竖屏
	
	# 传统比例
	"1600x1200": Vector2(1600, 1200),  # 4:3 专业显示器
	"1024x768": Vector2(1024, 768),    # 4:3 XGA
	"800x600": Vector2(800, 600),      # 旧式设备
	
	# 你的原始数据
	"1200x720": Vector2(1200, 720),
	"960x540": Vector2(960, 540),
	
	# 特殊用途
	"4096x2160": Vector2(4096, 2160)   # 4K DCI 电影标准
}

const step = 2
const cp_prob=0.3

var lang = TranslationServer.get_loaded_locales()

var dest=Vector2(0,0)
var dest_scale = Vector2(0.3,0.3)

const data_file_path = "user://data/data.json"
#var data_file_path = OS.get_executable_path().get_base_dir()+"/data/data.json"

var data_file = FileAccess.open(data_file_path,FileAccess.READ_WRITE)

var data = data_template.duplicate(true)

var data_loaded = false

var total = 0
var card_number = []
var card_type = []

var need_shuffle = true
var ind = 0
var background_no=1

var history = []

var picker_scene = load("res://scenes/picker.tscn")
var settings_scene = load("res://scenes/settings/settings.tscn")
var special_scene = load("res://scenes/special_scene/special.tscn")

func _ready():
	print("Globals data start loading.")
	if FileAccess.file_exists(data_file_path):
		data_file = FileAccess.open_encrypted_with_pass(data_file_path,FileAccess.READ_WRITE,uni_pass)
		if data_file:print("Data from file read:"+data_file.get_as_text())
		if not data_file:
			print("Invalid data file encrypted,retrying")
			data_file = FileAccess.open(data_file_path,FileAccess.READ_WRITE)
			if data_file:print("Data from file read:"+data_file.get_as_text())
			data = JSON.parse_string(data_file.get_as_text())
			print(data_file.get_as_text())
			if not data:
				create()
		print(data_file.get_as_text())
		data = JSON.parse_string(data_file.get_as_text())
		if not data:
			create()
	else:
		print("Data File not fund")
		create()
		
	print("Checking data")
	data = check_and_fix_data(data,data_template)
	if data["data"]["settings"]["background"]!=null:
		if not FileAccess.file_exists(data["data"]["settings"]["background"]):
			data["data"]["settings"]["background"]=null
	data["version"]=ProjectSettings.get_setting("application/config/version")
	print("Checked")
	
	print("TranslationServer Set:",data["data"]["settings"]["lang"])
	TranslationServer.set_locale(data["data"]["settings"]["lang"])
	
	print("Window Rescaling")
	if data["data"]["settings"]["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		if change_res(res[Globals.data["data"]["settings"]["res"]])==-1:
			Globals.data["data"]["settings"]["res"]="800x600"
			print("Invalid res found, replacing with 800x600")
			change_res(res[Globals.data["data"]["settings"]["res"]])
		
	print("Data initiate complete")
	print("Calculating total number of students")
	
	calculate_total()
	
	print("Entering picker.tscn")
	background_no=randi_range(1,3)
	
func create():
	print("Creating data file.")
	data = null
	data = data_template.duplicate(true)
	data_file = FileAccess.open_encrypted_with_pass(data_file_path,FileAccess.WRITE,uni_pass)
	var temp_data = JSON.stringify(data)
	if (FileAccess.get_open_error()==7):
		var access = DirAccess.open("user://")
		access.make_dir_recursive("user://data")
		data_file = FileAccess.open_encrypted_with_pass(data_file_path,FileAccess.WRITE,uni_pass)
	print(FileAccess.get_open_error())
	data_file.resize(0)
	data_file.store_string(temp_data)
	data_file.flush()
	data_file.close()
	data_file = FileAccess.open(data_file_path,FileAccess.READ_WRITE)


func save():
	print("Saving data")
	data_file.close()
	data_file=FileAccess.open_encrypted_with_pass(data_file_path,FileAccess.WRITE,uni_pass)
	var json = JSON.new()
	var temp_data = json.stringify(Globals.data)
	data_file.seek(0)
	data_file.store_string(temp_data)
	data_file.flush()
	data_file.close()
	print("Saved")

func check_and_fix_data(data: Dictionary, default_values: Dictionary, parent_key: String = "") -> Dictionary:
	for key in default_values:
		var full_key = "%s/%s" % [parent_key, key] if parent_key else key
		
		if not key in data:
			print("Fixing missing data:", full_key)
			data[key] = default_values[key].duplicate(true) if default_values[key] is Dictionary else default_values[key]
		
		else:
			if data[key] is Dictionary and default_values[key] is Dictionary and key != "cp":
				data[key] = check_and_fix_data(data[key], default_values[key], full_key)
			elif typeof(data[key]) != typeof(default_values[key]) and key != "background":
				push_error("Type not match while checking: %s (Expected %s, Found %s)" % [
					full_key,
					type_string(typeof(default_values[key])),
					type_string(typeof(data[key]))
				])
	return data


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("App Closing")
		save()
	
func  calculate_total():
	var except_array = Globals.data["data"]["settings"]["except"]
	var seen = {}
	var result = []

	for num in except_array:
		if not seen.has(num):
			seen[num] = true
			result.append(num)

	Globals.data["data"]["settings"]["except"] = result
	var start = data["data"]["settings"]["range"][0]
	var end = data["data"]["settings"]["range"][1]
	var except_set = data["data"]["settings"]["except"].filter(func(x): return x >= start and x <= end)
	total = (end - start + 1) - except_set.size()

func change_res(resolution):
	if resolution in res.values() and resolution.x<=DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()).x and resolution.y<=DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()).y:
		get_window().size=resolution
		var screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
		var window_size = resolution
		var centered_pos = Vector2i(
			(screen_size.x - window_size.x) / 2,
			(screen_size.y - window_size.y) / 2
		)
		DisplayServer.window_set_position(centered_pos)
		RenderingServer.force_draw()
	else:
		return -1
