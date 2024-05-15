extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > -2152:
		self.position.y -= 1
		if Input.is_action_pressed('credit scroll'):
			self.position.y -= 3
	
	


func _on_quit_pressed():
	get_tree().quit()


func _on_play_again_pressed():
	get_tree().change_scene_to_file('res://First Scene.tscn')


func _on_main_menu_pressed():
	get_tree().change_scene_to_file('res://Main menu.tscn')
