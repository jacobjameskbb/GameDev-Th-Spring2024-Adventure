extends CharacterBody2D

@onready var player = $"../Player"
var animation_over = false


func _on_scene_trigger_body_entered(body):
	if body.is_in_group('player'):
		if not animation_over:
			animation_over = true
			player = body
			body.can_move = false
			body.velocity.x = 0
			body.get_node('AnimatedSprite2D').animation = 'standing'
			$"../DebtCollectorCutscene".play('DebtCollector')
			


func _on_cashier_cutscene_animation_finished(anim_name):
	if anim_name == 'Scary':
		player.can_move = true
		
 


func _on_debt_collector_cutscene_animation_finished(_anim_name):
	$"../StaticBody2D/FallDownSimulatorCollisionShape".disabled = true
	player.can_move = true
