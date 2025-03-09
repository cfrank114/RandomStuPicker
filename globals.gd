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
				"except":[6,32,42],
				"fullscreen":true,
				"lang":"en_US",
				"range":[1,49],
				"res":"1920x1080",
				"tab_at_bottom":false
				}
			},
		"version":"1.3-alpha1"
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
	"gold":Vector4(107,80,32,255),
	"purple":Vector4(83,48,191,255),
	"blue":Vector4(107,126,149,255),
	"pink":Vector4(195,63,123,255)
	}
	
const res = {
	"1920x1080":Vector2(1920,1080),
	"1200x720":Vector2(1200,720),
	"960x540":Vector2(960,540)
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

var total = data["data"]["settings"]["range"][1]-data["data"]["settings"]["range"][0]+1-len(data["data"]["settings"]["except"])
var card_number = []
var card_type = []

var need_shuffle = true
var settings_changed = false
var ind = 0

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
	data["version"]=ProjectSettings.get_setting("application/config/version")
	print("Checked")
	total = data["data"]["settings"]["range"][1]-data["data"]["settings"]["range"][0]+1-len(data["data"]["settings"]["except"])
	print("TranslationServer Set:",data["data"]["settings"]["lang"])
	TranslationServer.set_locale(data["data"]["settings"]["lang"])
	print("Window Rescaling")
	if data["data"]["settings"]["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		get_window().size=res[Globals.data["data"]["settings"]["res"]]
		get_window().position=Vector2(120,100)
		
	print("Data initiate complete")
	print("Entering picker.tscn")
	
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
	# 遍历默认值字典进行校验
	for key in default_values:
		# 构造完整键路径用于调试信息
		var full_key = "%s/%s" % [parent_key, key] if parent_key else key
		
		# 检查字段是否存在
		if not key in data:
			# 如果字段缺失，使用默认值填充
			print("Fixing missing data:", full_key)
			data[key] = default_values[key].duplicate(true) if default_values[key] is Dictionary else default_values[key]
		
		else:
			# 递归处理嵌套字典
			if data[key] is Dictionary and default_values[key] is Dictionary and key != "cp":
				data[key] = check_and_fix_data(data[key], default_values[key], full_key)
			# 类型不匹配时的错误处理
			elif typeof(data[key]) != typeof(default_values[key]):
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
	
