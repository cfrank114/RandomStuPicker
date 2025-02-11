extends Node2D

@onready var number_a = $card/number_a
@onready var number_b = $card/number_b
@onready var card = $card
@onready var number_colors = Globals.number_color
@export var finished=false
var _type=""

const speed = 5.0

func set_pos(pos:Vector2,allow_cards=true):
	self.position = pos
	if allow_cards:
		self.scale = Vector2(0.01,0.01)
	else: 
		self.scale = Globals.dest_scale
		if _type=="gold":
			self.scale=1.02*Globals.dest_scale
			self.position.y+=10
	
	
func set_card(number:int,type:String,allow_cards=true):
	if(allow_cards):
		number_a.material.set_shader_parameter("color",number_colors[type]/255)
		number_b.material.set_shader_parameter("color",number_colors[type]/255)
		card.play(type)
	else:
		number_a.material.set_shader_parameter("color",Vector4(0,0,0,1))
		number_b.material.set_shader_parameter("color",Vector4(0,0,0,1))
		card.play("none")
	var num_a_value = number/10
	var num_b_value = number%10
	number_a.play(str(num_a_value))
	number_b.play(str(num_b_value))
	_type = type
	

func _ready():
	set_card(0,"normal")

func _process(delta):
	if(abs(self.position.y-Globals.dest.y)<1 and abs(self.position.x-Globals.dest.x)<1):
		finished=true
		return
	finished = false
	var pos = self.position
	var sc = self.scale
	var dest = Globals.dest
	var dest_scale = Globals.dest_scale
	pos.x+=(dest.x-pos.x)*delta*speed
	pos.y+=(dest.y-pos.y)*delta*speed
	sc.x+=(dest_scale.x-sc.x)*delta*speed
	sc.y+=(dest_scale.y-sc.y)*delta*speed
	self.position=pos
	self.scale = sc
	
	
