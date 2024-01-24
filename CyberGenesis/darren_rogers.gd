extends CharacterBody2D

const RUN_SPEED = 300.0
const CRAWL_SPEED = 200.0
var speed = 300.0
const JUMP_VELOCITY = -220.0

var crouching = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const right_arm_offset = Vector2(12,4)
const left_arm_offset = Vector2(-12,4)

func _physics_process(delta):
	if Input.is_action_just_pressed('player_crouch'):
		crouching = true
		$CollisionStanding.disabled = true
		speed = CRAWL_SPEED
	elif Input.is_action_just_released('player_crouch'):
		speed = RUN_SPEED
		if true:
			$CollisionStanding.disabled = false
			position.y-=4
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	#manage visual sprite
	$Arms.look_at(get_global_mouse_position())
	if $Arms.flip_h:
		$Arms.rotation_degrees += 180
	if get_global_mouse_position().x > self.global_position.x:
		$Body.flip_h = false
		$Arms.flip_h = false
		$Arms.position = $RightArmsPosition.position
		$Arms.offset = right_arm_offset
	else:
		$Body.flip_h = true
		$Arms.flip_h = true
		$Arms.position = $LeftArmsPosition.position
		$Arms.offset = left_arm_offset
	if Input.is_action_pressed("player_left"):
		if Input.is_action_pressed('player_crouch'):
			if not $Body.flip_h:
				$Body.play_backwards('crawling')
			else:
				$Body.play("crawling")
		else:
			if not $Body.flip_h:
				$Body.play_backwards("walking")
			else:
				$Body.play('walking')
	elif Input.is_action_pressed("player_right"):
		if Input.is_action_pressed('player_crouch'):
			if $Body.flip_h:
				$Body.play_backwards('crawling')
			else:
				$Body.play("crawling")
		else:
			if $Body.flip_h:
				$Body.play_backwards("walking")
			else:
				$Body.play('walking')
	else:
		if Input.is_action_pressed('player_crouch'):
			$Body.play('crouching')
		else:
			$Body.play('standing')
	if not is_on_floor():
		if Input.is_action_pressed('player_crouch'):
			$Body.play("crouch jumping")
		else:
			$Body.play('jumping')

	move_and_slide()
