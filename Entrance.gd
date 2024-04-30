extends Area2D

var player_in = false
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Text.set_text('Press "F"')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in:
		$Text.fade_in()
	else:
		$Text.fade_out()


func _on_body_entered(body):
	if body.is_in_group('player'):
		print('player detected')
		player_in = true
		player.interactions['scene1_enter'] = true


func _on_body_exited(body):
	if body.is_in_group('player'):
		player_in = false
		player.interactions['scene1_enter'] = false
