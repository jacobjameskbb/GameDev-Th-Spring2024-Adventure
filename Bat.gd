extends CharacterBody2D

const ROTATION_SPEED = 10

var damage = 16
var swinging = false

func _ready():
	hide()

func swing():
	show()
	$AnimationPlayer.play('bat_attack')
	swinging = true
	$Area2D/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
		
		
func wait(time_in_seconds):
	await get_tree().create_timer(time_in_seconds).timeout


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'bat_attack':
		hide()
		swinging = false
		$Area2D/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true

func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
		body.attack(damage, 'bat')
