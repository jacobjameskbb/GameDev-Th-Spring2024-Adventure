extends CharacterBody2D


const SPEED = 300.0
@export_enum('left', 'right') var initial_direction: String
@onready var direction = initial_direction


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	print(direction)
	if direction == 'left':
		velocity.x = -SPEED
	else:
		velocity.x = SPEED


	move_and_slide()


func _on_wall_detect_body_entered(body):
	if body.is_in_group('wall'):
		scale.x = -scale.x
		if direction == 'left':
			direction = 'right'
			print(direction)
		if direction == 'right':
			direction = 'left'
