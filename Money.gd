extends Node2D

var speed = 100

var x_dir = randi_range(-1,1)
var y_mag = randi_range(1,5)
var x_mag = randi_range(1,5)
var y_offset = randi_range(-20,20)

var move = Vector2(x_dir*x_mag,-y_mag)

var coin_value = 1

var can_pick_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var coin_type = randi_range(1,15)
	if coin_type <= 10:
		coin_value = 1
		$Sprite.play("coin")
	elif coin_type <= 15 and coin_type > 10:
		coin_value = 5
		$Sprite.play("dollar")
	
	
	self.position.y += y_offset

func _physics_process(delta):
	if move.y <= y_mag:
		self.position += speed * delta * move
		move += Vector2(0,delta*25 )

func commit_suicide():
	self.queue_free()

func _on_player_detect_body_entered(body):
	if body.is_in_group("player") and can_pick_up:
		body.collect_coin(coin_value)
		commit_suicide()


func _on_timer_timeout():
	can_pick_up = true
