extends Area2D

var player_near = false
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_near:
		$Text.fade_in()
		player.interactions['scene2_enter'] = true
	else:
		$Text.fade_out()
		player.interactions['scene2_enter'] = false


func _on_body_entered(body):
	if body.is_in_group('player'):
		
		player_near = true
		


func _on_body_exited(body):
	if body.is_in_group('player'):
		player_near = false
