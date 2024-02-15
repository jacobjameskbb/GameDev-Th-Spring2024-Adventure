extends CharacterBody2D

const MOVEMENT_SPEED = 300
const ROTATION_SPEED = 20

var collided_with_wall: bool = false

var direction: String = ''

var colliding_with_player = false

func _ready():
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	
	if not collided_with_wall:
		if direction == 'left':
			position.x -= MOVEMENT_SPEED * delta
			rotation_degrees -= ROTATION_SPEED
		elif direction == 'right':
			position.x += MOVEMENT_SPEED * delta
			rotation_degrees += ROTATION_SPEED
		else:
			print_debug('SELF_DEBUG: ROTATION FOR CARD NOT BEING SET OR NOT BEING SET CORRECTLY')




#--FUNCTIONS--
func enable_collision():
	while colliding_with_player:
		await get_tree().process_frame
	$CollisionShape2D.disabled = false
   

#--AREAS--
func _on_area_body_entered(body):
	if body.is_in_group('wall'):
		collided_with_wall = true
		call_deferred('enable_collision')
	if body.is_in_group('player'):
		colliding_with_player = true


func _on_area_body_exited(body):
	if body.is_in_group('player'):
		colliding_with_player = false
