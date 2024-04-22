extends Node

@export var delay = 0.5

@export var running = false
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	step()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func step():
	if running:
		play()
	await get_tree().create_timer(delay).timeout
	step()

func play():
	random.randomize()
	var node_number = random.randi_range(0, get_child_count()-1)
	get_child(node_number).play()
	
func start():
	running = true
	
func stop():
	running = false
