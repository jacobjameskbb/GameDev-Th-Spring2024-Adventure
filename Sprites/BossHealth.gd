extends Node2D
@export var max_health = 5
@onready var health = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func death():
	$"../../World/DebtCollectorBoss".kill_cards()
	$"../../World/DebtCollectorBoss".death()
