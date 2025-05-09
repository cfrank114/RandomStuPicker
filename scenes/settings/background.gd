extends Button

@onready var file_dir=Globals.data["data"]["settings"]["background"]
@onready var old_dir=Globals.data["data"]["settings"]["background"]


func update_text():
	if Globals.data["data"]["settings"]["background"]==null:
		self.text=tr("Menu_Settings_Background_None")
	else:
		self.text=Globals.data["data"]["settings"]["background"]

func _ready():
	update_text()

func _pressed():
	$FileDialog.show()
	
func _on_file_dialog_canceled() -> void:
	file_dir = old_dir
	Globals.data["data"]["settings"]["background"]=file_dir
	update_text()
	$"../../../../../..".background_update()


func _on_file_dialog_confirmed() -> void:
	old_dir=file_dir
	$FileDialog.hide()
	Globals.data["data"]["settings"]["background"]=file_dir
	update_text()
	$"../../../../../..".background_update()


func _on_file_dialog_file_selected(path: String) -> void:
	file_dir=path
	Globals.data["data"]["settings"]["background"]=file_dir
	update_text()
	$"../../../../../..".background_update()


func _on_file_dialog_close_requested() -> void:
	Globals.data["data"]["settings"]["background"]=null
	update_text()
	$"../../../../../..".background_update()


func _on_file_dialog_ready() -> void:
	if OS.get_name() == "Windows":$FileDialog.current_dir="C:/"
	if file_dir!=null:$FileDialog.current_dir=file_dir.get_base_dir()
