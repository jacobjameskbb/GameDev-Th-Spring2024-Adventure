extends Node2D

@onready var coin = load("res://money.tscn")
@onready var projectile = load("res://purple_projectile.tscn")

var angle_sum = 0

@export var wander_range = 200

@export var speed = 100

var target_position = self.global_position

var starting_position = self.global_position

var shoot_target = self

var state = "idle"

var health = 16

var coin_amount = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play("fly")
	target_position = self.global_position
	starting_position = self.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	adjust_angle_sum(delta)
	hover()
	
	var direction = Vector2.ZERO
	
	if state == "idle":
		set_state("wander")
		
	if state == "wander":
		direction  = (target_position - self.position).normalized()
		
		if self.position.distance_squared_to(target_position) <= 2:
			set_state("return")
		
	if state == "return":
		direction = (starting_position - self.position).normalized()
		
		if self.position.distance_squared_to(starting_position) <= 2:
			set_state("wander")
	
	if direction.x <= 0:
		$Sprite.scale.x = 2
	elif direction.x > 0:
		$Sprite.scale.x = -2
	
	self.position += speed * direction * delta
	
	
func set_state(new_state):
	if new_state == "idle":
		target_position = "self"
	
	elif new_state == "wander":
		get_new_target()
		
	elif new_state == "return":
		target_position = starting_position
		
	elif new_state == "attack":
		pass

	state = new_state

func death():
	for i in range(1,coin_amount):
		var new_coin = coin.instantiate()
		new_coin.position = self.position
		get_parent().call_deferred("add_child",new_coin)
	
	queue_free()

func get_new_target():
	var random_angle = randf_range(0,(2*PI))
	
	target_position = starting_position + wander_range * Vector2(cos(random_angle), 0.5*sin(random_angle))

func hover():
	self.position.y += 0.75 * sin(angle_sum)

func adjust_angle_sum(delta):
	angle_sum += 10*delta
	
	if angle_sum >= 2*PI:
		angle_sum = 0

func shoot():
	var new_projectile = projectile.instantiate()
	new_projectile.direction = Vector2(1,0).rotated((shoot_target.position - self.position).angle())
	new_projectile.position = self.position + 20 * new_projectile.direction
	new_projectile.rotation = new_projectile.direction.angle()
	get_parent().call_deferred("add_child",new_projectile)

func take_damage(damage):
	health -= damage
	if health <= 0:
		death()

func _on_player_detect_body_entered(body):
	if body.is_in_group("player"):
		shoot_target = body
		set_state("attack")
		
		$Sprite.scale.x = 2 * (body.position.x - self.position.x) / abs(body.position.x - self.position.x)
		
		shoot()

func _on_attack_timer_timeout():
	if state == "attack":
		shoot()


func _on_player_detect_body_exited(body):
	set_state("wander")


func _on_hitbox_body_entered(body):
	if body.is_in_group("bat"):
		print('Hit!')
		take_damage(body.get_parent().damage_bat)
