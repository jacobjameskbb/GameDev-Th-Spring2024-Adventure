extends CharacterBody2D

#Loaded scenes
var preload_card = preload("res://Nodes/Card/card.tscn")

#Constant variables
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	on_floor = is_on_floor()
	
	#-Set the velocity-
	if not on_floor:
		velocity.y += gravity * delta

	if on_floor and just_pressed_jump:
		velocity.y = JUMP_VELOCITY
		
	if pressed_left and velocity.x > -SPEED:
		velocity.x -= ACCELERATION
		if velocity.x < -SPEED:
			velocity.x = SPEED
	elif velocity.x<0:
		velocity.x += ACCELERATION
		if velocity.x > 0:
			velocity.x = 0
		
		
	if pressed_right and velocity.x < SPEED:
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
	#-----VISUALS-----
	if pressed_left:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.animation = 'walking'
	if pressed_right:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.animation = 'walking'
	if not pressed_left and not pressed_right:
		$AnimatedSprite2D.animation = 'standing'

#-----FUNCTIONS-----

func shoot(direction):
	var new_card = preload_card.instantiate()
	get_parent().add_child(new_card)
	new_card.global_position = self.global_position + Vector2(0,10)
	new_card.direction = direction
