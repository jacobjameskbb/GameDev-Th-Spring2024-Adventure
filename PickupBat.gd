extends CharacterBody2D

var player_near = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $"../Player".player_level > 0:
		$"../Text".fade_out()
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		player_near = true
		$"../Text".set_text('"F" Pickup bat')
		$"../Text".fade_in()
		body.interactions['pickup_bat'] = true


func _on_area_2d_body_exited(body):
	if body.is_in_group('player'):
		player_near = false
		$"../Text".fade_out()
		body.interactions['pickup_bat'] = false
