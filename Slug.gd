extends RigidBody2D

@onready var sprite = $Sprite
@onready var collisions = [$HeadShape,$BodyShape]

var player = self

var current_state = 'idle'

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(current_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_state == "panic":
		linear_velocity.x = (player.position.x - self.position.x)/abs(player.position.x - self.position.x)
	
	#move_and_collide(Vector2(linear_velocity.x,0))

func set_state(new_state):
	if new_state == "idle":
		sprite.play("default")
		
	elif new_state == "panic":
		sprite.play("move")
		
	elif new_state == "squish":
		sprite.play("squish")
		
	current_state = new_state

func die():
	pass

func _on_sprite_animation_finished():
	if sprite.animation == 'squish':
		die()


func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		player = body
		
