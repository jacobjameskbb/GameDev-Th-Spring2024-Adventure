extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Volume.value = Global.volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('escape'):
		if not get_tree().paused:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(0))
			get_tree().paused = true
			self.show()
			
		else:
			self.hide()
			get_tree().paused = false


func _on_resume_pressed():
	self.hide()
	get_tree().paused = false


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file('res://Main menu.tscn')


func _on_quit_pressed():
	get_tree().quit()


func _on_volume_value_changed(value):
	Global.volume = value
