extends CharacterBody2D

	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_scene_trigger_body_entered(body):
	if body.is_in_group('player'):
		body.can_move = false
		body.velocity.x = 0
		body.get_node('AnimatedSprite2D').animation = 'standing'
		$"../CashierCutscene".play("Scary")
