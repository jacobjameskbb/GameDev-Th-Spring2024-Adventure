extends CharacterBody2D

@export var damage = 10

@export var max_health = 20
@onready var health = max_health

const SPEED = 70
@export_enum('left', 'right') var direction: String

const DAMAGE_JUMP = 200

#dead variable
var dead = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	$AnimatedSprite2D.play('walking')
	
func _physics_process(delta):
	
	# Add the gravity.
	velocity.y += gravity * delta
	if direction == 'left':
		velocity.x = -SPEED
	else:
		velocity.x = SPEED

	if dead:
		velocity.x = 0
	move_and_slide()
	
#---------FUNCTIONS------------
func death():
	$AnimatedSprite2D.play('death')
	dead = true

#---------CONNECTIONS-----------------------
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
		if is_on_floor() and not dead:
			velocity.y = -DAMAGE_JUMP
	if body.is_in_group('card'):
		health -= body.get_parent().damage
		if is_on_floor() and not dead:
			velocity.y = -DAMAGE_JUMP
	


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == 'death':
		queue_free()
