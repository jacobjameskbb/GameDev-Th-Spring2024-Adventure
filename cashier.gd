extends CharacterBody2D
var sprite_positions = {
	'1' = Vector2(0,0),
	'2' = Vector2(157, 0),
	'3' = Vector2(157+157, 0)
	}

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