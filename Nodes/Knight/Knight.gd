extends CharacterBody2D

#-----VARIABLES-----
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var target_location = null
var state = 'attacking'

var dead = false


#-----BASE FUNCTIONS-------
func _ready():
	$AnimTorso.play(state)
	$AnimLegs.play("default")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	

	if not dead:
		if state == 'standing':
			#Animation
			$AnimTorso.animation = 'standing'
			$AnimLegs.speed_scale = 0
			$AnimLegs.frame = 0
		if state == 'walking':
			#Animation
			$AnimTorso.animation = 'walking'
			$AnimLegs.speed_scale = 1
		if state == 'attacking':
			#Animation
			$AnimTorso.animation = 'attacking'
			$AnimLegs.speed_scale = 2
			
	if dead:
		velocity.x = 0
	move_and_slide()
