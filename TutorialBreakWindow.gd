extends Area2D

var player_near = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_near and $"../Player".player_level >0 and not $"../Window".broken:
		$Text.fade_in()
	else:
		$Text.fade_out()


func _on_body_entered(body):
	if body.is_in_group('player'):
		player_near = true
		


func _on_body_exited(body):
	if body.is_in_group('player'):
		player_near = false
