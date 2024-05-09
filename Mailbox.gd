extends CharacterBody2D

var attack_over = true

@export var max_health = 25
@onready var health = max_health

@export var attack_cooldown = 1.9
@export var damage = 20
@onready var cooldown_seconds_passed = 0.9

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

var preload_mail = preload('res://mail.tscn')

var random = RandomNumberGenerator.new()

@export var SPEED = 50

#States: Peaceful, Rising, Standing, Walking, Attacking
var state = 'ground'
var dead = false

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')


# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	$AnimatedSprite2D.play("ground")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	velocity.y += gravity
	if not dead:
		if (touching_walls['left_attack'] or touching_walls['right_attack']) and state != 'ground' and state != 'rising':
			state = 'attacking'
			velocity.x = 0
			attack_over = false
			previous_position = null
			position_countdown = RESET_POSITION_COUNTDOWN
		if state == 'ground':
			$AnimatedSprite2D.play('ground')
			if touching_walls['left_attack'] or touching_walls['right_attack'] or health < max_health:
				state = 'rising'
		if state == 'rising':
			$AnimatedSprite2D.play('rising')

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
			await get_tree().create_timer(random.randf_range(0.5,3)).timeout
			state = 'walking'
		if state == 'attacking':
			cooldown_seconds_passed += delta
			print(cooldown_seconds_passed)
			var player = get_parent().get_node('Player')
			if player.position.x < self.position.x:
				if direction == 'right':
					direction = 'left'
					$AnimatedSprite2D.scale.x *= -1
			else:
				if direction == 'left':
					direction = 'right'
					$AnimatedSprite2D.scale.x *= -1
			$AnimatedSprite2D.play('attacking')
			if not touching_walls['left_attack'] and not touching_walls['right_attack'] and attack_over:
				state = 'standing'
				cooldown_seconds_passed = 0.9
			if cooldown_seconds_passed >= attack_cooldown:
				shoot()
				cooldown_seconds_passed = 0
				attack_over = false
	move_and_slide()
	
func shoot():
	var mail = preload_mail.instantiate()
	get_parent().add_child(mail)
	mail.direction = {'left': -1, 'right': 1}[direction]
	mail.global_position = {'left': $MailSpawnLeft.global_position, 'right': $MailSpawnRight.global_position}[direction]
	mail.damage = self.damage

func attack(damage, type='none'):
	health -= damage
	if health <= 0:
		queue_free()


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





func _on_animated_sprite_2d_animation_looped():
	if $AnimatedSprite2D.animation == 'rising':
		state = 'standing'
	if $AnimatedSprite2D.animation == 'attacking':
		attack_over = true
