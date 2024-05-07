extends CharacterBody2D

var damage = 4
var range = 0
var range_counter = 0

const MOVEMENT_SPEED = 300
const ROTATION_SPEED = 20
const DELETE_TIME_SECONDS = 15

var collided_with_wall: bool = false

var direction: String = ''

var colliding_with_player = false

func _ready():
	$CollisionShape2D.disabled = true
	for i in range(0,10):
		move(1)
	
	

func _physics_process(delta):
	if not collided_with_wall:
		range_counter += delta
		if range_counter >= range:
			queue_free()
	
	if not collided_with_wall:
		move(delta)




#--FUNCTIONS--
func enable_collision():
	while colliding_with_player:
		await get_tree().process_frame
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(DELETE_TIME_SECONDS).timeout
	queue_free()
	
func move(delta):
	if direction == 'left':
		position.x -= MOVEMENT_SPEED * delta
		rotation_degrees -= ROTATION_SPEED
	elif direction == 'right':
		position.x += MOVEMENT_SPEED * delta
		rotation_degrees += ROTATION_SPEED
	else:
		pass
		#print_debug('SELF_DEBUG: ROTATION FOR CARD NOT BEING SET OR NOT BEING SET CORRECTLY, ', direction)
  


#--AREAS--
func _on_area_body_entered(body):
	if body.is_in_group('wall'):
		collided_with_wall = true
		call_deferred('enable_collision')
	if body.is_in_group('player'):
		colliding_with_player = true
	if body.is_in_group('enemy'):
		body.attack(damage, 'card')
	if body.is_in_group('bat') or body.is_in_group('card kill'):
		queue_free()


func _on_area_body_exited(body):
	if body.is_in_group('player'):
		colliding_with_player = false


func die_if_placed():
	if collided_with_wall:
		queue_free()
