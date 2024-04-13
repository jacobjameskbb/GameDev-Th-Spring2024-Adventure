extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play_text('This is a test text', 0, $"../PickupBat".player_near)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_text(text, time = 0, condition = true):
	$Label.text = text
	$Animation.play('fade')
	await get_tree().create_timer(1+time).timeout
	while not condition:
		await get_tree().process_frame
	$Animation.play('fade out')
