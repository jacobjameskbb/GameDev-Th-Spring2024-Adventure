extends Area2D

func _on_body_entered(body):
	if body.is_in_group('player'):
		$"../Player/Camera2D".position_smoothing_speed = 15
