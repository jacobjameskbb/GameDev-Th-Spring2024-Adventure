extends Node2D
var played = false
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('player') and not played:
		played = true
		body.can_move = false
		body.get_node('AnimatedSprite2D').animation = 'standing'
		body.velocity.x = 0
		$AnimationPlayer.play('new_animation')


func _on_animation_player_animation_finished(anim_name):
	player.can_move = true
