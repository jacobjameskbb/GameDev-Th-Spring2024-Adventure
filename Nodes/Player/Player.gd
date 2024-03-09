extends CharacterBody2D


@export var damage_bat = 16
@export var damage_card = 4
@export var card_cooldown = 0.4

@export var max_health = 100
@onready var health = max_health

var cooldown = false


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

#dead variable
var dead = false

func _ready():
	$Bat.damage = damage_bat
	

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
	if not dead:
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
	elif dead:
		velocity.x = 0
			
	#move
	move_and_slide()
	
	#-----OTHER CONTROLS----
	if not dead:
		if just_pressed_shoot_left and not cooldown:
			shoot('left')
			cooldown = true
		if just_pressed_shoot_right and not cooldown:
			shoot('right')
			cooldown = true
		
		if just_pressed_attack_bat:
			$Bat.attack(direction)
	#-----VISUALS-----
	if not dead:
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
	new_card.global_position = self.global_position + Vector2(0,15)
	new_card.direction = direction
	new_card.damage = damage_card
	await get_tree().create_timer(card_cooldown).timeout
	cooldown = false
	
func death():
	$AnimatedSprite2D.play('death')
	dead = true
	
func attack(damage):
	health -= damage

#------CONNECTIONS-----------------

func _on_animated_sprite_2d_animation_looped():
	if $AnimatedSprite2D.animation == 'death':
		$AnimatedSprite2D.speed_scale = 0
		$AnimatedSprite2D.frame = 4

