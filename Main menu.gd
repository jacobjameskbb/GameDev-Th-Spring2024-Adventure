extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.volume = $Settings/VBoxContainer/Volume.max_value/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_volume_value_changed(value):
	Global.volume = value


func _on_back_pressed():
	$Settings.hide()
	$Main.show()


func _on_play_pressed():
	get_tree().change_scene_to_file('res://First Scene.tscn')


func _on_settings_pressed():
	$Settings.show()
	$Main.hide()
