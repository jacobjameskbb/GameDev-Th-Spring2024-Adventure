extends CharacterBody2D

var broken = false
var player_near = false
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_near and broken:
		player.interactions['scene3_enter'] = true
	else:
		player.interactions['scene3_enter'] = false


func _on_area_2d_body_entered(body):
	if body.is_in_group('bat'):
		$AnimatedSprite2D.frame += 1
		broken = true
	if body.is_in_group('player'):
		player_near = true
		


func _on_area_2d_body_exited(body):
	if body.is_in_group('player'):
		player_near = false
