extends Node2D

var direction = Vector2(1,0)

var speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * delta * direction


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.attack(5)
		self.queue_free()
	elif body.is_in_group("bat"):
		self.queue_free()
