extends CharacterBody2D

var state = 'jumping'
var animation_over = false
var direction = 'left'

var random = RandomNumberGenerator.new()

var card_list = []
var card_child_list = []


# Called when the node enters the scene tree for the first time.
func _ready():
	jump(1)
	self.remove_from_group('wall')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
		
		



func jump(amount):
	$AnimatedSprite2D.offset.x = -8
	$AnimatedSprite2D.offset.y = 0
	self.position.y = 0
	
	var jumped_amount = 0
	while(jumped_amount < amount):
		$AnimatedSprite2D.play("Stand")
		if direction == 'left':
			$"../AnimationPlayer".play('jump')
			direction = 'right'
			jumped_amount += 1
		elif direction == 'right':
			$"../AnimationPlayer".play('jump backwards')
			direction = 'left'
			jumped_amount += 1
		await get_tree().create_timer(2).timeout
		$AnimatedSprite2D.scale.x *= -1
		$AnimatedSprite2D.play('Shoot')
		await get_tree().create_timer(3).timeout
	tall(direction)
	
func tall(direction):
	self.add_to_group('wall')
	$AnimatedSprite2D.offset.x = 1
	$AnimatedSprite2D.offset.y = -7.5
	self.position.y = -230
	$AnimatedSprite2D.play("Tall")
	await get_tree().create_timer(5).timeout
	self.remove_from_group('wall')
	for card in card_list:
		card.queue_free()
	for card in card_child_list:
		card.get_parent().queue_free()
	$AnimatedSprite2D.play_backwards('Tall')
	jump(1)





func _on_area_2d_body_entered(body):
	if body.is_in_group('card'):
		card_list.append(body)
	if body.is_in_group('card child'):
		card_child_list.append(body)
		print(body.name)


func _on_area_2d_body_exited(body):
	if body.is_in_group('card'):
		card_list.erase(body)
	if body.is_in_group('card child'):
		card_child_list.erase(body)
