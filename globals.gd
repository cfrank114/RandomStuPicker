extends Node

const app_ver = "1.1.1"

const data_template = {"data":{"constants":{"cp":{"10":[43,48],"15":[39],"17":[48],"19":[37],"22":[45],"33":[38,44],"4":[46],"7":[40,49]},"special":[12]},"settings":{"allow_cards":true,"allow_cp":false,"auto_erase_history":true,"except":[6,32,42],"fullscreen":true,"lang":"en","range":[1,49],"res":"1200x720","tab_at_bottom":false}},"version":"1.1"}

const number_color={
	"normal":Vector4(143,143,143,255),
	"gold":Vector4(205,176,0,255),
	"purple":Vector4(122,111,238,255),
	"blue":Vector4(74,194,183,255),
	"pink":Vector4(255,129,129,255)
	}
	
const res = {
	"1920x1080":Vector2(1920,1080),
	"1200x720":Vector2(1200,720),
	"960x540":Vector2(960,540)
}

var lang = ["de","en","ja","zh"]

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

func _ready():
	if FileAccess.file_exists(data_file_path):
		data_file = FileAccess.open(data_file_path,FileAccess.READ_WRITE)
		data = JSON.parse_string(data_file.get_as_text())
		if not data:
			create()
	else:
		create()
	total = data["data"]["settings"]["range"][1]-data["data"]["settings"]["range"][0]+1-len(data["data"]["settings"]["except"])
	TranslationServer.set_locale(data["data"]["settings"]["lang"])
	if data["data"]["settings"]["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		get_window().size=res[Globals.data["data"]["settings"]["res"]]
		get_window().position=Vector2(120,100)
	
func create():
	data = null
	data = data_template.duplicate(true)
	data_file = FileAccess.open(data_file_path,FileAccess.WRITE_READ)
	var temp_data = JSON.stringify(data)
	if (FileAccess.get_open_error()==7):
		var access = DirAccess.open("user://")
		access.make_dir_recursive("user://data")
		data_file = FileAccess.open(data_file_path,FileAccess.WRITE_READ)
	print(FileAccess.get_open_error())
	data_file.resize(0)
	data_file.store_string(temp_data)
	data_file.flush()


func save():
	var json = JSON.new()
	var temp_data = json.stringify(Globals.data)
	data_file.resize(0)
	data_file.seek(0)
	data_file.store_string(temp_data)
	data_file.close()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
	
