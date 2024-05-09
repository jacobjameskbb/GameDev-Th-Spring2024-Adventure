extends Node2D

@export var start_spawn = false
var entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if start_spawn:
		Global.spawnpoint = $Spawn.global_position
		entered = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		if not entered:
			entered = true
			Global.spawnpoint = $Spawn.global_position
