extends CharacterBody2D

var state = 'jumping'
var animation_over = false
var direction = 'left'

var random = RandomNumberGenerator.new()

var bullet_preload = preload("res://bullet.tscn")

var health

var damaged = false

var dead = false

@onready var player = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	jump(1)
	self.remove_from_group('wall')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = $"../../CanvasLayer/Health".health
	if health <= 0:
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
		await get_tree().create_timer(0,5).timeout
		shoot(direction)
		if jumped_amount < amount:
			await get_tree().create_timer(5).timeout
	await get_tree().create_timer(5).timeout
	tall(direction)
	
func tall(direction):
	damaged = false
	spawn_enemy()
	self.add_to_group('wall')
	$AnimatedSprite2D.offset.x = 1
	$AnimatedSprite2D.offset.y = -7.5
	self.position.y = -230
	$AnimatedSprite2D.play("Tall")
	var count = 0
	while count < 150 and not damaged:
		await get_tree().create_timer(0.1).timeout
		count += 1
	self.remove_from_group('wall')
	kill_cards()
	if not dead:
		$AnimatedSprite2D.play_backwards('Tall')
		await get_tree().create_timer(2).timeout
		jump(random.randi_range(2,3))
	
func shoot(direction = 'left', amount = 5):
	for i in range(amount):
		var new_bullet = bullet_preload.instantiate()
		get_parent().add_child(new_bullet)
		if direction == 'left':
			new_bullet.direction = -1
			new_bullet.global_position = $BulletPositionRight.global_position
			new_bullet.scale.x *= -1
		else:
			new_bullet.direction = 1
			new_bullet.global_position = $BulletPositionLeft.global_position
		await get_tree().create_timer(1).timeout
	

func spawn_enemy():
	var spawn_position
	if player.global_position.x < $Center.global_position.x:
		spawn_position = $LeftEnemySpawn.global_position
	else:
		spawn_position = $RightEnemySpawn.global_position
		
	if health == 5:
		pass
	elif health == 4:
		pass
	elif health == 3:
		pass
	elif health == 2:
		pass
	elif health == 1:
		pass






func _on_bat_detect_body_entered(body):
	if body.is_in_group('bat'):
		if not damaged:
			damaged = true
			$"../../CanvasLayer/Health".health -= 1
			
func kill_cards():
	for child in get_parent().get_children():
		if child.is_in_group('card'):
			child.die_if_placed()
			
func death():
	dead = true
	modulate = Color(0.9, 0, 0)
	await get_tree().create_timer(1).timeout
	$"../../CanvasLayer/FadeOut".fade()
	
