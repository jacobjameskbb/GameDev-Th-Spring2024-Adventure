extends CharacterBody2D


const SPEED = 70
@export_enum('left', 'right') var direction: String


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$AnimatedSprite2D.play('walking')
	
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
	if body.is_in_group('wall enemy'):
		scale.x = -scale.x
		if direction == 'left':
			direction = 'right'
		elif direction == 'right':
			direction = 'left'
