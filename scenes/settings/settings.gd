extends Control

@onready var node_from = $"TabContainer/Menu_Settings/ScrollContainer/Items/Range/From"
@onready var node_to = $"TabContainer/Menu_Settings/ScrollContainer/Items/Range/To"

func translate():
	print("Settings Translation")
	$TabContainer/Menu_Info/VBoxContainer/Others/about.text = tr("Menu_Info_Description_Author")+":cfrank114\n"+tr("Menu_Info_Description_BugReport")+" :https://github.com/cfrank114/RandomStuPicker/issues"
	$TabContainer/Menu_Info/VBoxContainer/Version/Ver.text = tr("Menu_Info_Ver_Software")+":"+str(ProjectSettings.get_setting("application/config/version"))+"\n"+tr("Menu_Info_Ver_Datapack")+":"+str(Globals.data["version"])
	$TabContainer/Menu_Settings/ScrollContainer/Items/Background/Background.update_text()
	
func _ready():
	print("Switched scene to Setting")
	translate()
	background_update()
	node_from.value=int(Globals.data["data"]["settings"]["range"][0])
	node_to.value=int(Globals.data["data"]["settings"]["range"][1])



func _on_from_value_changed(new_value: float) -> void:
	if(new_value>0 and new_value<Globals.data["data"]["settings"]["range"][1] and new_value!=Globals.data["data"]["settings"]["range"][0]):
		Globals.data["data"]["settings"]["range"][0]=node_from.value
		Globals.calculate_total()
		Globals.need_shuffle=true
		$TabContainer/Menu_Settings/ScrollContainer/Items/Except/ScrollContainer/VBoxContainer.upd()
	else:
		node_from.value=Globals.data["data"]["settings"]["range"][0]
	

func _on_to_value_changed(new_value: float) -> void:
	if(new_value<100 and new_value>Globals.data["data"]["settings"]["range"][0] and new_value!=Globals.data["data"]["settings"]["range"][1]):
		Globals.data["data"]["settings"]["range"][1]=node_to.value
		Globals.calculate_total()
		Globals.need_shuffle=true
		$TabContainer/Menu_Settings/ScrollContainer/Items/Except/ScrollContainer/VBoxContainer.upd()

	else:
		node_to.value=Globals.data["data"]["settings"]["range"][1]
	


func _on_fullscreen_ready() -> void:
	$TabContainer/Menu_Settings/ScrollContainer/Items/Fullscreen.visible=OS.get_name() not in ["Android","iOS"]

func background_update():
	if Globals.data["data"]["settings"]["background"] == null:
		$Background.texture=load("res://assets/backgrounds/background"+str(Globals.background_no)+".png")
	else:
		$Background.texture=ImageTexture.create_from_image(Image.load_from_file(Globals.data["data"]["settings"]["background"]))


func _on_fast_cp_turn_off_ready() -> void:
	if Globals.data["data"]["settings"]["allow_cp"]:$TabContainer/Menu_Settings/ScrollContainer/Items/FastCPTurnOff.show()


func _on_turnoffcp_pressed() -> void:
	Globals.data["data"]["settings"]["allow_cp"]=false
