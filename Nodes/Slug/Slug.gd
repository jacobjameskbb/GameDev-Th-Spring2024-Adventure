extends CharacterBody2D

@onready var coin = load("res://money.tscn")

@onready var sprite = $Sprite
@onready var collisions = [$HeadShape,$BodyShape]

@export var coin_amount = 10

var player = self

var current_state = 'idle'

var speed = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(current_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity.y += 9.8
	
	if current_state == "panic":
		var direction = -(player.position.x - self.position.x)/abs(player.position.x - self.position.x)
		velocity.x = direction*speed
		
		sprite.scale.x = -direction
	
	elif current_state == 'squish':
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func set_state(new_state):
	if new_state == "idle":
		sprite.play("default")
		
	elif new_state == "panic":
		sprite.play("move")
		
	elif new_state == "squish":
		for collider in collisions:
			collider.set_deferred("disabled",true)
		
		sprite.play("squish")
		
	current_state = new_state

func die():
	for i in range(1,coin_amount):
		var new_coin = coin.instantiate()
		new_coin.position = self.position
		get_parent().call_deferred("add_child",new_coin)
	
	queue_free()

func _on_sprite_animation_finished():
	if sprite.animation == 'squish':
		die()

func _on_sprite_animation_looped():
	if sprite.animation == 'squish':
		sprite.stop()
		die()

func _on_player_detect_body_entered(body):
	if body.is_in_group("player") and current_state != "squish":
		player = body
		set_state("panic")
		


func _on_squish_detect_body_entered(body):
	if body.is_in_group("player"):
		set_state("squish")



