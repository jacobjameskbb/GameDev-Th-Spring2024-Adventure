extends CharacterBody2D

const ROTATION_SPEED = 10

func _ready():
	pass

func attack(direction):
	if direction == 'right':
		position = Vector2(17.5,-4.5)
		rotation_degrees = -60
		wait(0.05)
		rotation_degrees += ROTATION_SPEED 
		while rotation_degrees != -60:
			rotation_degrees += ROTATION_SPEED
			wait(0.05)
		
		
func wait(time_in_seconds):
	await get_tree().create_timer(time_in_seconds).timeout
