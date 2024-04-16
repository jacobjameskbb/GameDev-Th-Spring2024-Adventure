extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group('player'):
		$Text.fade_in()
		$Text.set_text('"F" Enter Basement')
		body.interactions['scene2_enter'] = true


func _on_body_exited(body):
	if body.is_in_group('player'):
		$Text.fade_out()
		body.interactions['scene2_enter'] = false
