extends CharacterBody2D
var speed = 200
var direction = 1
var damage = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale.x *= direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed * direction
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group('bat'):
		queue_free()
	if body.is_in_group('player'):
		body.attack(damage)
