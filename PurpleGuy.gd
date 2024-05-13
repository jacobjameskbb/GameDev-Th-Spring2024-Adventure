extends Node2D

var angle_sum = 0

@export var wander_range = 200

@export var speed = 100

var target_position = self.global_position

var starting_position = self.global_position

var state = "idle"

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

func get_new_target():
	var random_angle = randf_range(0,(2*PI))
	
	target_position = starting_position + wander_range * Vector2(cos(random_angle), 0.5*sin(random_angle))

func hover():
	self.position.y += 0.75 * sin(angle_sum)

func adjust_angle_sum(delta):
	angle_sum += 10*delta
	
	if angle_sum >= 2*PI:
		angle_sum = 0
