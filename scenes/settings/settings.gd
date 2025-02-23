extends Control


func translate():
	print("Settings Translation")
	$TabContainer/Menu_Info/VBoxContainer/Others/about.text = tr("Menu_Info_Description_Author")+":cfrank114\n"+tr("Menu_Info_Description_BugReport")+" :https://github.com/cfrank114/RandomStuPicker/issues"
	$TabContainer/Menu_Info/VBoxContainer/Version/Ver.text = tr("Menu_Info_Ver_Software")+":"+str(ProjectSettings.get_setting("application/config/version"))+"\n"+tr("Menu_Info_Ver_Datapack")+":"+str(Globals.data["version"])
	
func _ready():
	print("Switched scene to Setting")
	translate()
