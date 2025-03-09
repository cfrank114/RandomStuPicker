extends Node2D

@onready var number_a = $card/number_a
@onready var number_b = $card/number_b
@onready var card = $card
@onready var number_colors = Globals.number_color
@onready var glow_colors = Globals.number_color
@onready var shader = preload("res://scenes/card/card.gdshader") 
@export var finished=false

var _type=""
var need_scaling=false

const speed = 5.0

func set_pos(pos:Vector2,allow_cards=true):
	self.position = pos
	if allow_cards:
		self.scale = Vector2(0.01,0.01)
		if need_scaling:
			self.scale*=1.02
			self.position.y+=70
			self.position.x+=10
	else: 
		self.scale = Globals.dest_scale
		if need_scaling:
			self.scale=1.02*Globals.dest_scale
			self.position.y+=10
	
	
func set_card(number:int,type:String,allow_log=true,allow_cards=true,scaling=false):
	if allow_log:print("Setting card:"+str(number)+" with type "+type)
	if(allow_cards):
		if Globals.data["data"]["settings"]["allow_glow_effect"]:
			$card.material.shader=shader
			var intensity=0
			if type=="gold":
				intensity=0.5
			elif type=="purple":
				intensity=0.5
			elif type=="blue":
				intensity=0.2
			elif type=="pink":
				intensity=0.2
			$card.material.set_shader_parameter("glow_color",glow_colors[type]/255)
			$card.material.set_shader_parameter("intensity",intensity)
			$card.material.set_shader_parameter("delta",randf())
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
	need_scaling=scaling
	

func _ready():
	set_card(0,"normal",false)

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
	
	
