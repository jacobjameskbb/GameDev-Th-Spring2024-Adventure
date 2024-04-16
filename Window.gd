extends CharacterBody2D

var broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('bat'):
		$AnimatedSprite2D.frame += 1


func _on_area_2d_body_exited(body):
	pass # Replace with function body.
