extends Node2D

var break_fade_out = false
var break_fade_in = false

var fading_in = false
var fading_out = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func play_text(text, time = 0):
	$Label.text = text
	$Animation.play('fade')
	await get_tree().create_timer(1+time).timeout
	$Animation.play('fade out')

func set_text(text):
	$Label.text = text
	
func fade_in():
	if not fading_in:
		print('fade in')
		fading_in = true
		break_fade_out = true
		break_fade_in = false
		$Label.global_position = self.global_position + Vector2(0,40)
		$Label.self_modulate.a = 0
		while $Label.self_modulate.a < 1:
			if break_fade_in: break
			await get_tree().create_timer(0.01).timeout
			$Label.self_modulate.a += 0.02
			$Label.position.y -= 0.3


func fade_out():
	fading_in = false
	if not fading_out:
		fading_out = true
		break_fade_out = false
		break_fade_in = true
		while $Label.self_modulate.a > 0:
			if break_fade_out: break
			await get_tree().create_timer(0.01).timeout
			$Label.self_modulate.a -= 0.02
			$Label.position.y -= 0.3
		fading_out = false
