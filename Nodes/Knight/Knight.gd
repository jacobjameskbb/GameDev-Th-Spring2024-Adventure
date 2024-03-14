extends CharacterBody2D

#-----VARIABLES-----
@export var max_health = 60
@onready var health = max_health

@export var damage = 30

const SPEED = 60.0
const ATTACKING_SPEED = 200
const JUMP_VELOCITY = -400.0

const STANDING_WAIT_RANGE = [1,5]
var stand_cooldown = null

const WALK_RANGE = 180

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var target_location = null
var state = 'walking'

var dead = false

var random = RandomNumberGenerator.new()

var touching_walls = {
	'bodies_left_normal' = [],
	'left_normal' = false,
	'bodies_right_normal' = [],
	'right_normal' = false,
	'bodies_attack' = [],
	'attack' = false,
}

var direction = 'left'

var player_far_range = false
var player_close_range = false

@onready var player = get_parent().get_node('Player')

var previous_position = null
@onready var position_countdown = RESET_POSITION_COUNTDOWN
const RESET_POSITION_COUNTDOWN = 5

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
		
		if player_far_range and state != 'attacking':
			state = 'attacking'
		if state == 'standing':
			#Animation
			$AnimTorso.animation = 'standing'
			$AnimLegs.speed_scale = 0
			$AnimLegs.frame = 0
			$CollisionAttacking.disabled = true
			$CollisionNormal.disabled = false
			#Movement
			velocity.x = 0
			if stand_cooldown == null:
				stand_cooldown = random.randi_range(STANDING_WAIT_RANGE[0], STANDING_WAIT_RANGE[1])
			else:
				stand_cooldown -= 1*delta
				if stand_cooldown <0:
					stand_cooldown = null
					state = 'walking'
		if state == 'walking':
			#variables
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
			$AnimTorso.animation = 'walking'
			$AnimLegs.speed_scale = 1
			$CollisionAttacking.disabled = true
			$CollisionNormal.disabled = false
			#Movement
			if target_location == null:
				target_location = self.position.x + random.randi_range(-WALK_RANGE, WALK_RANGE)
			if target_location > self.position.x:
				velocity.x = SPEED
				if direction == 'left':
					direction = 'right'
					scale.x = -1
				if target_location <= self.position.x + SPEED or touching_walls['right_normal']:
					state = 'standing'
					target_location = null
					previous_position = null
					position_countdown = RESET_POSITION_COUNTDOWN
			elif target_location < self.position.x:
				velocity.x = -SPEED
				if direction == 'right':
					direction = 'left'
					scale.x = -1
				if target_location >= self.position.x - SPEED or touching_walls['left_normal']:
					state = 'standing'
					position_countdown = RESET_POSITION_COUNTDOWN
					previous_position = null
					target_location = null
		if state == 'attacking':
			#Animation
			$AnimTorso.animation = 'attacking'
			if velocity.x == 0:
				$AnimLegs.speed_scale = 0
			else:
				$AnimLegs.speed_scale = 2
			$CollisionAttacking.disabled = false
			$CollisionNormal.disabled = true
			if player.position.x > self.position.x:
				if direction == 'left':
					direction = 'right'
					scale.x = -1
				if not player_close_range:
					velocity.x = ATTACKING_SPEED
				else:
					velocity.x = 0
			if player.position.x < self.position.x:
				if direction == 'right':
					direction = 'left'
					scale.x = -1
				if not player_close_range:
					velocity.x = -ATTACKING_SPEED
				else:
					velocity.x = 0
			if direction == 'left':
				for body in touching_walls['bodies_attack']:
					if body.global_position.x < self.global_position.x and is_on_floor():
						velocity.y = JUMP_VELOCITY
						break
			if direction == 'right':
				for body in touching_walls['bodies_attack']:
					if body.global_position.x > self.global_position.x and is_on_floor():
						velocity.y = JUMP_VELOCITY
						break
			if not player_far_range:
				state = 'standing'
			
		
		#----VISUALS-------
			
	if dead:
		velocity.x = 0
	move_and_slide()
	
#-------FUNCTIONS--------
func update_walls(walls):
	if walls == 'left_normal':
		if len(touching_walls['bodies_left_normal']) == 0:
			touching_walls['left_normal'] = false
		else:
			touching_walls['left_normal'] = true
	if walls == 'right_normal':
		if len(touching_walls['bodies_right_normal']) == 0:
			touching_walls['right_normal'] = false
		else:
			touching_walls['right_normal'] = true
			
	if walls == 'attack':
		if len(touching_walls['bodies_attack']) == 0:
			touching_walls['attack'] = false
		else:
			touching_walls['attack'] = true

func attack(amount, type):
	health -= amount
	
func death():
	queue_free()
#--------CONNECTIONS--------
func _on_detect_wall_left_body_entered(body):
	if body.is_in_group('wall'):
		if direction == 'left':
			touching_walls['bodies_left_normal'].append(body)
			update_walls('left_normal')
		else:
			touching_walls['bodies_right_normal'].append(body)
			update_walls('right_normal')

func _on_detect_wall_left_body_exited(body):
	if body.is_in_group('wall'):
		if direction == 'left':
			touching_walls['bodies_left_normal'].erase(body)
			update_walls('left_normal')
		else:
			touching_walls['bodies_right_normal'].erase(body)
			update_walls('right_normal')

func _on_detect_wall_right_body_entered(body):
	if body.is_in_group('wall'):
		if direction == 'left':
			touching_walls['bodies_right_normal'].append(body)
			update_walls('right_normal')
		else:
			touching_walls['bodies_left_normal'].append(body)
			update_walls('left_normal')

func _on_detect_wall_right_body_exited(body):
	if body.is_in_group('wall'):
		if direction == 'left':
			touching_walls['bodies_right_normal'].erase(body)
			update_walls('right_normal')
		else:
			touching_walls['bodies_left_normal'].erase(body)
			update_walls('left_normal')


func _on_detect_player_far_body_entered(body):
	if body.is_in_group('player'):
		player_far_range = true


func _on_detect_player_far_body_exited(body):
	if body.is_in_group('player'):
		player_far_range = false





func _on_detect_wall_attack_body_entered(body):
	if body.is_in_group('parkour obstacle'):
		touching_walls['bodies_attack'].append(body)
		update_walls('attack')


func _on_detect_wall_attack_body_exited(body):
	if body.is_in_group('parkour obstacle'):
		touching_walls['bodies_attack'].erase(body)
		update_walls('attack')


func _on_detect_close_player_body_entered(body):
	if body.is_in_group('player'):
		player_close_range = true


func _on_detect_close_player_body_exited(body):
	if body.is_in_group('player'):
		player_close_range = false
		


func _on_anim_torso_animation_looped():
	if $AnimTorso.animation == 'attacking' and player_close_range:
		player.attack(damage, 'none')
