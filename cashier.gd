extends CharacterBody2D

var player
var animation_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
		
 
