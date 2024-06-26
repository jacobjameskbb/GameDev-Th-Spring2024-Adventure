extends CharacterBody2D

var state = 'jumping'
var animation_over = false
var direction = 'left'

var spawn_direction = 1

var random = RandomNumberGenerator.new()

var bullet_preload = preload("res://bullet.tscn")

var health

var damaged = false

var dead = false

@onready var player = $"../Player"

@onready var knight = preload('res://Nodes/Knight/knight.tscn')
@onready var purple = preload('res://purple_guy.tscn')
@onready var mailbox = preload('res://mailbox.tscn')
@onready var green = preload('res://Nodes/GoombaAlien/goomba_alien.tscn')
@onready var slug = preload('res://Nodes/Slug/slug.tscn')


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
	if player.global_position.x > $"../Center".global_position.x:
		spawn_position = $"../LeftEnemySpawn".global_position
		spawn_direction = 1
	else:
		spawn_position = $"../RightEnemySpawn".global_position
		spawn_direction = -1
		
	if health == 5:
		spawn(slug, spawn_position + Vector2(-200*spawn_direction,20))
		spawn(slug, spawn_position + Vector2(-100*spawn_direction,20))
	elif health == 4:
		spawn(green, spawn_position)
		spawn(green, spawn_position + Vector2(20,20))
	elif health == 3:
		spawn(mailbox, spawn_position)
	elif health == 2:
		spawn(purple, $"../Center".global_position + Vector2(0,100))
		#spawn(purple, $"../Center".global_position + Vector2(-20*spawn_direction,130))
		#spawn(purple, $"../Center".global_position + Vector2(-40*spawn_direction,160))
	elif health == 1:
		spawn(knight, spawn_position)






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
	
func spawn(enemy, given_position):
	if health != 2:
		var new_enemy = enemy.instantiate()
		new_enemy.global_position = given_position
		get_parent().add_child(new_enemy)
	else:
		print('player_position: ',player.global_position)
		var new_enemy = enemy.instantiate()
		get_parent().add_child(new_enemy)
		new_enemy.global_position = given_position
		new_enemy.target_position = Vector2(580, 221)
		new_enemy.starting_position = Vector2(580, 221)
		new_enemy.set_starting_positions()
		


func _on_fade_out_finished_fade():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file('res://final milk store.tscn')

