extends CharacterBody2D

#States: Peaceful, Rising, Standing, Walking, Attacking

var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walking")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity
	move_and_slide()
