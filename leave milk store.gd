extends Area2D

var player_near = false
@onready var player = $"../../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_near:
		$Text.fade_in()
		player.interactions['scene_store_exit'] = true
	else:
		$Text.fade_out()
		player.interactions['scene_store_exit'] = false


func _on_body_entered(body):
	if body.is_in_group('player'):
		
		player_near = true
		


func _on_body_exited(body):
	if body.is_in_group('player'):
		player_near = false
