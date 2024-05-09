extends Node2D
@onready var player =  get_parent().get_node('Player')
var player_in = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in:
		$Text.fade_in()
		player.interactions['next_level'] = true
	else:
		$Text.fade_out()
		player.interactions['next_level'] = false


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		player_in = true


func _on_area_2d_body_exited(body):
	if body.is_in_group('player'):
		player_in = false
		
