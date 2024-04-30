extends CharacterBody2D

var previous_position = null
@onready var position_countdown = RESET_POSITION_COUNTDOWN
const RESET_POSITION_COUNTDOWN = 5
var target_location = null
const STANDING_WAIT_RANGE = [1,5]
var stand_cooldown = null
const WALK_RANGE = 180
var direction = 'left'

var touching_walls = {
	'left_normal' = false,
	'right_normal' = false,
	'left_attack' = false,
	'right_attack' = false,
}

var random = RandomNumberGenerator.new()

@export var SPEED = 50

#States: Peaceful, Rising, Standing, Walking, Attacking
var state = 'walking'
var dead = false

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')


# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	$AnimatedSprite2D.play("peaceful")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity.y += gravity
	if not dead:
		if touching_walls['left_attack'] == true or touching_walls['right_attack'] == true:
			state = 'attacking'
			velocity.x = 0
			previous_position = null
			position_countdown = RESET_POSITION_COUNTDOWN
			
		if state == 'walking':
			if previous_position == null:
				previous_position = self.position
			position_countdown -= 1
			if position_countdown <= 0:
				position_countdown = RESET_POSITION_COUNTDOWN
				if position == previous_position:
					state = 'standing'
					previous_position = null
					target_location = null
				else:
					previous_position = self.position
			#Animation
			$AnimatedSprite2D.play('walking')

			#Movement
			if target_location == null:
				target_location = self.position.x + random.randi_range(-WALK_RANGE, WALK_RANGE)
			if target_location > self.position.x:
				velocity.x = SPEED
				if direction == 'left':
					direction = 'right'
					$AnimatedSprite2D.scale.x *= -1
				if target_location <= self.position.x + SPEED or touching_walls['right_normal']:
					state = 'standing'
					target_location = null
					previous_position = null
					position_countdown = RESET_POSITION_COUNTDOWN
			elif target_location < self.position.x:
				velocity.x = -SPEED
				if direction == 'right':
					direction = 'left'
					$AnimatedSprite2D.scale.x *= -1
				if target_location >= self.position.x - SPEED or touching_walls['left_normal']:
					state = 'standing'
					position_countdown = RESET_POSITION_COUNTDOWN
					previous_position = null
					target_location = null
		if state == 'standing':
			state = 'walking'
		if state == 'attacking':
			$AnimatedSprite2D.play('attacking')
			if not touching_walls['left_attack'] and not touching_walls['right_attack']:
				state = 'standing'
			if $AnimatedSprite2D.frame == 8:
				pass
				#attack
	move_and_slide()


func _on_detect_wall_left_body_entered(body):
	if body.is_in_group('wall enemy'):
		touching_walls['left_normal'] = true


func _on_detect_wall_left_body_exited(body):
	if body.is_in_group('wall enemy'):
		touching_walls['left_normal'] = false


func _on_detect_wall_right_body_entered(body):
	if body.is_in_group('wall enemy'):
		touching_walls['right_normal'] = true


func _on_detect_wall_right_body_exited(body):
	if body.is_in_group('wall enemy'):
		touching_walls['right_normal'] = false


func _on_detect_wall_left_attack_body_entered(body):
	if body.is_in_group('player'):
		touching_walls['left_attack'] = true


func _on_detect_wall_left_attack_body_exited(body):
	if body.is_in_group('player'):
		touching_walls['left_attack'] = false
		


func _on_detect_wall_right_attack_body_entered(body):
	if body.is_in_group('player'):
		touching_walls['right_attack'] = true


func _on_detect_wall_right_attack_body_exited(body):
	if body.is_in_group('player'):
		touching_walls['right_attack'] = false
