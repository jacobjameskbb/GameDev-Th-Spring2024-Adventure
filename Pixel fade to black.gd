extends Node2D 

var last_pixel = Vector2(143, 80)
var random = RandomNumberGenerator.new()
var all_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	for x in range(144):
		for y in range(81):
			all_positions.append(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fade():
	while len(all_positions)> 0:
		for i in range(100):
				if len(all_positions)<=0:
					break
				var new_position = all_positions[random.randi_range(0,len(all_positions)-1)]
				$TileMap.set_cell(0, Vector2(new_position), 0, Vector2i(0,0), 0)
				all_positions.erase(new_position)
		await get_tree().create_timer(0.01).timeout
