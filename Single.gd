extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play(sound):
	if sound == 'jumpscare':
		$Jumpscare.play()
	if sound == 'critters':
		$Critters.play()
	if sound == 'lightswitch':
		$LightSwitch.play()
	if sound == 'smash1':
		$smash1.play()
	if sound == 'smash2':
		$smash2.play()
	if sound == 'smash3':
		$smash3.play()
