extends CharacterBody2D

@export var max_health = 20
@onready var health = max_health

const SPEED = 70
@export_enum('left', 'right') var direction: String

const DAMAGE_JUMP = 200


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$AnimatedSprite2D.play('walking')
	
func _physics_process(delta):
	print(health)
	
	# Add the gravity.
	velocity.y += gravity * delta
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
	


func _on_attack_detect_body_entered(body):
	if body.is_in_group('bat'):
		health -= body.damage
		if is_on_floor():
			velocity.y = -DAMAGE_JUMP
	if body.is_in_group('card'):
		health -= body.get_parent().damage
		if is_on_floor():
			velocity.y = -DAMAGE_JUMP
