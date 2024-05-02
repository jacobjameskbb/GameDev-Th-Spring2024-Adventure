extends CharacterBody2D

var direction = 1
var speed = 40
@export var damage = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = direction*speed*delta*1000
	move_and_slide()


func _on_player_detect_body_entered(body):
	if body.is_in_group('player'):
		body.attack(damage)
