extends Button

func _onready():
	$"../../VBoxContainer".visible=false

func _pressed():
	print("Validate")
	var input = $"../LineEdit".text
	var keypair = ""
	var time = Time.get_datetime_dict_from_system()
	keypair+=str(10-(time.hour+time.day)%10)
	keypair+=str((time.minute/10+time.day/10)%10)
	keypair+=str(10-(time.minute+time.month)%10)
	keypair+=str((time.year+time.hour/10)%10)
	if(keypair==input):
		$"../../VBoxContainer".visible=true
		$"..".visible=false
