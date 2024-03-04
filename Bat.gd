extends CharacterBody2D

const ROTATION_SPEED = 10

var damage
var swinging = false

func _ready():
	hide()

func attack(direction):
	show()
	$AnimationPlayer.play('bat_attack')
	swinging = true
		
		
func wait(time_in_seconds):
	await get_tree().create_timer(time_in_seconds).timeout


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'bat_attack':
		hide()
		swinging = false
