extends Area2D

func _on_body_entered(body):
	print('hi', body)
	if body.is_in_group('player'):
		body.in_air = true
		$"../../Sounds/GrassWalking".stop()

func _on_body_exited(body):
	if body.is_in_group('player'):
		body.in_air = false
		
