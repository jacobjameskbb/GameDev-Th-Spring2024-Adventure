extends Node2D

@onready var player = $"../Player"
var money = false

var place = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.player_level == 2 and not player.threw_card:
		print('1 fade in')
		$Throw.fade_in()
	else:
		$Throw.fade_out()
		
	if player.player_level == 2 and not player.swung_bat and player.threw_card:
		$Remove.fade_in()
	else:
		$Remove.fade_out()
	
	if player.swung_bat:
		$Climb.fade_in()
	else:
		$Climb.fade_out()
	if money:
		$Money.fade_in()
	else:
		$Money.fade_out()

	if place:
		$Place.fade_in()
	else:
		$Place.fade_out()

func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		money = true


func _on_area_2d_2_body_entered(body):
	if body.is_in_group('player'):
		place = true
