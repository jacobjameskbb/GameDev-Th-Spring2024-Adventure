extends CharacterBody2D

var state = 'jumping'
var animation_over = false
var direction = 'left'

var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	jump(random.randi_range(2,3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
		
		


func _on_animation_player_animation_finished(anim_name):
	$Sprite2D.scale.x *= -1

func jump(amount):
	var jumped_amount = 0
	while(jumped_amount < amount):
		if direction == 'left':
			$"../AnimationPlayer".play('jump')
			direction = 'right'
			jumped_amount += 1
		elif direction == 'right':
			$"../AnimationPlayer".play('jump_backwards')
			direction = 'left'
			jumped_amount += 1
		await get_tree().create_timer(5).timeout
	tall(direction)
	
func tall(direction):
	pass
