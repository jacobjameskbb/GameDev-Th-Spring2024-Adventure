extends CharacterBody2D

#-----VARIABLES-----
const SPEED = 60.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var target_location = null
var state = 'walking'

var dead = false

var random = RandomNumberGenerator.new()

#-----BASE FUNCTIONS-------
func _ready():
	random.randomize()
	$AnimTorso.play(state)
	$AnimLegs.play("default")

func _physics_process(delta):
	random.randomize()
	# Add the gravity.
	velocity.y += gravity * delta
	

	if not dead:
		if state == 'standing':
			#Animation
			$AnimTorso.animation = 'standing'
			$AnimLegs.speed_scale = 0
			$AnimLegs.frame = 0
			$CollisionAttacking.disabled = true
			$CollisionNormal.disabled = false
			#Movement
			velocity.x = 0
		if state == 'walking':
			#Animation
			$AnimTorso.animation = 'walking'
			$AnimLegs.speed_scale = 1
			$CollisionAttacking.disabled = true
			$CollisionNormal.disabled = false
			#Movement
			if target_location == null:
				target_location = self.position.x + random.randi_range(-300, 300)
				print(target_location)
			if target_location > self.position.x:
				velocity.x = SPEED
				if target_location <= self.position.x + SPEED:
					state = 'standing'
			elif target_location < self.position.x:
				velocity.x = -SPEED
				if target_location >= self.position.x - SPEED:
					state = 'standing'
		if state == 'attacking':
			#Animation
			$AnimTorso.animation = 'attacking'
			$AnimLegs.speed_scale = 2
			$CollisionAttacking.disabled = false
			$CollisionNormal.disabled = true
			
	if dead:
		velocity.x = 0
	move_and_slide()
