extends Area2D

var player_in = false
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in:
		$Sprite2D.show()
	else:
		$Sprite2D.hide()


func _on_body_entered(body):
	if body.is_in_group('player'):
		player_in = true
		player.scene1_can_enter = true


func _on_body_exited(body):
	if body.is_in_group('player'):
		player_in = false
		player.scene1_can_enter = false
