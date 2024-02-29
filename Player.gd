extends CharacterBody2D

#Loaded scenes
var preload_card = preload("res://Nodes/Card/card.tscn")

#Constant variables
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 'right'

#Create control/other bool variables
var pressed_left: bool = false
var pressed_right: bool = false
var pressed_jump: bool = false

var just_pressed_left: bool = false
var just_pressed_right: bool = false
var just_pressed_jump: bool = false

var on_floor: bool = false

var pressed_shoot_left: bool = false
var pressed_shoot_right: bool = false

var just_pressed_shoot_left: bool = false
var just_pressed_shoot_right: bool = false

var pressed_attack_bat: bool = false
var just_pressed_attack_bat: bool = false



func _ready():
	pass

func _physics_process(delta):
	#------MOVEMENT------
	
	#-Set movement/other bool variables-
	pressed_left = Input.is_action_pressed('left')
	pressed_right = Input.is_action_pressed('right')
	pressed_jump = Input.is_action_pressed('jump')
	
	just_pressed_left = Input.is_action_just_pressed('left')
	just_pressed_right = Input.is_action_just_pressed('right')
	just_pressed_jump = Input.is_action_just_pressed('jump')
	
	pressed_shoot_left = Input.is_action_pressed('launch card left')
	pressed_shoot_right = Input.is_action_pressed('launch card right')
	
	just_pressed_shoot_left = Input.is_action_just_pressed('launch card left')
	just_pressed_shoot_right = Input.is_action_just_pressed('launch card right')
	
	pressed_attack_bat = Input.is_action_pressed('bat attack')
	just_pressed_attack_bat = Input.is_action_just_pressed('bat attack')
	
	on_floor = is_on_floor()
	
	#-Set the velocity-
	if not on_floor:
		velocity.y += gravity * delta

	if on_floor and just_pressed_jump:
		velocity.y = JUMP_VELOCITY
		
	if pressed_left and velocity.x > -SPEED and not $Bat.swinging and direction == 'left':
		velocity.x -= ACCELERATION
		if velocity.x < -SPEED:
			velocity.x = SPEED
	elif velocity.x<0:
		velocity.x += ACCELERATION
		if velocity.x > 0:
			velocity.x = 0
		
		
	if pressed_right and velocity.x < SPEED and not $Bat.swinging and direction == 'right':
		velocity.x += ACCELERATION
		if velocity.x > SPEED:
			velocity.x = SPEED
	elif velocity.x>0:
		velocity.x -= ACCELERATION
		if velocity.x < 0:
			velocity.x = 0
			
	#move
	move_and_slide()
	
	#-----OTHER CONTROLS----
	if just_pressed_shoot_left:
		shoot('left')
	if just_pressed_shoot_right:
		shoot('right')
	
	if just_pressed_attack_bat:
		$Bat.attack(direction)
	#-----VISUALS-----
	if (pressed_right and direction == 'left' and not pressed_left) or (pressed_left and direction == 'right' and not pressed_right):
			scale.x = -2
			if direction == 'left':
				direction = 'right'
			else:
				direction = 'left'
	if $Bat.swinging:
		$AnimatedSprite2D.animation = 'attack bat'
	else:
		
		if pressed_left:
			$AnimatedSprite2D.animation = 'walking'
		if pressed_right:
			$AnimatedSprite2D.animation = 'walking'
		if not pressed_left and not pressed_right:
			$AnimatedSprite2D.animation = 'standing'
	

	

#-----FUNCTIONS-----

func shoot(direction):
	var new_card = preload_card.instantiate()
	get_parent().add_child(new_card)
	new_card.global_position = self.global_position + Vector2(0,10)
	new_card.direction = direction
