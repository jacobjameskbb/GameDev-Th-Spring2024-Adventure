extends CharacterBody2D

var player
var animation_over = false

func _on_scene_trigger_body_entered(body):
	if body.is_in_group('player'):
		if not animation_over:
			animation_over = true
			player = body
			body.can_move = false
			body.velocity.x = 0
			body.get_node('AnimatedSprite2D').animation = 'standing'
			$"../CashierCutscene".play('Scary')
			


func _on_cashier_cutscene_animation_finished(anim_name):
	if anim_name == 'Scary':
		player.can_move = true
		
 
