extends Control
const card_type=["gold","purple","blue","normal"]
@onready var type_num = [Globals.total*0.08,Globals.total*0.25]
func swap_with_ind(arr:Array,ind:Array,ida:int,idb:int):
	var swap_location_a = ind[ida]
	var swap_location_b = ind[idb]
	var tmp = arr[swap_location_a]
	arr[swap_location_a]=arr[swap_location_b]
	arr[swap_location_b]=tmp
	ind[ida]=swap_location_b
	ind[idb]=swap_location_a

func order(arr:Array,ind:Array):
	for i in range(len(arr)):
		ind[arr[i]]=i
	
func random_shuffle():
	print("shuffle")
	
	var _range = Globals.data["data"]["settings"]["range"]
	var _except = Globals.data["data"]["settings"]["except"]
	
	Globals.card_number=[]
	Globals.card_type=[]
	
	var cn = [] 					# card_number in function
	var ni=range(_range[1]+1)		# number index
	var ct = []						# card_type in function
	var remain = []					# I don't know
	
	#region Shuffle cards
	for i in range(_range[0],_range[1]+1):
		if not(float(i) in _except):
			cn.append(i)
			ct.append("normal")
	cn.shuffle()
	#endregion
	
	#region Shuffle card type
	remain=cn.duplicate()
	remain.shuffle()
	order(cn,ni)
	for i in range(type_num.reduce(func(a,num):return a+int(num))):
		for j in range(len(type_num)):
			if(i<=type_num[j]):
				ct[ni[remain[i]]]=card_type[j+1]
				break
	#endregion
	
	if Globals.data["data"]["settings"]["allow_cp"] and Globals.total>0:
		var cp:Dictionary = Globals.data["data"]["constants"]["cp"]
		var skip = false
		var cped=[]
		for i in range(Globals.total-1):
			if(skip or randf()>0.4):
				skip = false
				continue
			if str(i) in cp.keys():
				var cpid = cp[str(i)].pick_random()
				if(ni[i]+1<Globals.total and ni[i]>1 and cpid not in cped and cn[ni[i]+1] not in cped):
					swap_with_ind(cn,ni,cpid,cn[ni[i]+1])
					print(i,cpid)
					#if(cn[ni[i]+1]!=cn[ni[cpid]] or ni[i]+1!=ni[cpid]):
						#order(cn,ni)
						#skip = true
						#continue
					cped.append(cpid)
					cped.append(i)
					skip = true
		
	
	if float(cn[0]) in Globals.data["data"]["constants"]["special"]:
		var tmp = cn[2]
		cn[2]=cn[0]
		cn[0]=tmp
	for i in Globals.data["data"]["constants"]["special"]:
		ct[ni[i]-2]="gold"
	if Globals.data["data"]["settings"]["allow_cp"] and Globals.total>0:
		var cp:Dictionary = Globals.data["data"]["constants"]["cp"]
		for i in range(Globals.total-2):
			if str(cn[i]) in cp.keys():
				if (float(cn[i+1])in cp[str(cn[i])]):
					ct[i]="pink"
					ct[i+1]="pink"
				
			
	Globals.card_number=cn
	Globals.card_type = ct


func _process(delta):
	if Globals.need_shuffle:
		random_shuffle()
		Globals.need_shuffle=false
