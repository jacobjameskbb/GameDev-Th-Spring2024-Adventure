extends Node2D

#Testing/Use Purpose
@export var get_health_from_parent = true
@export var hide_when_full = true

#Make new variables for health
var max_health = 100
var health = 100


func _ready():
	if get_health_from_parent:
		max_health = get_parent().max_health
		health = get_parent().health
	
		


func _process(delta):
	health = get_parent().health
	max_health = get_parent().max_health
	if hide_when_full and $HealthRect.size.x == 100:
		hide()
	else:
		show()
	if not get_health_from_parent:
		if Input.is_action_just_pressed("ui_accept"):
			health -= 1
	print('health: ', health, ' max_health: ', max_health)
	$HealthRect.size.x = int((float(health)/float(max_health))*100)
