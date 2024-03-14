extends Node2D

#Testing/Use Purpose
@export var get_health_from_parent = true
@export var hide_when_full = true
@export var hide_when_empty = true
var dead = false
#Make new variables for health
var max_health = 10
var health = 5


func _ready():
	if get_health_from_parent:
		max_health = get_parent().max_health
		health = get_parent().health
	
		

 
func _process(delta):
	if get_health_from_parent:
		health = get_parent().health
		max_health = get_parent().max_health
	if hide_when_full and $HealthRect.size.x == 100 or hide_when_empty and $HealthRect.size.x == 0:
		hide()
	else:
		show()
		
		
	if not get_health_from_parent:
		if Input.is_action_just_pressed("ui_accept"):
			health -= 1
	$HealthRect.size.x = int((float(health)/float(max_health))*100)
	if health <= 0 and not dead:
		get_parent().death()
		dead = true
