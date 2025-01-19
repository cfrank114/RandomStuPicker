extends Node

const app_ver = 1.0

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

var dest=Vector2(0,0)
var dest_scale = Vector2(0.3,0.3)

const data_file_path = "res://data/data.json"
#var data_file_path = OS.get_executable_path().get_base_dir()+"/data/data.json"

var data_file = FileAccess.open(data_file_path,FileAccess.READ_WRITE)

@export var data:Dictionary = JSON.parse_string(data_file.get_as_text())

var total = data["data"]["settings"]["range"][1]-data["data"]["settings"]["range"][0]+1-len(data["data"]["settings"]["except"])
var card_number = []
var card_type = []

var need_shuffle = true
var settings_changed = false

func _ready():
	if data["data"]["settings"]["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		get_window().size=res[Globals.data["data"]["settings"]["res"]]
		get_window().position=Vector2(120,100)
	
func save():
	var json = JSON.new()
	var temp_data = json.stringify(Globals.data)
	data_file.resize(0)
	data_file.store_string(temp_data)
	data_file.close()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
	
