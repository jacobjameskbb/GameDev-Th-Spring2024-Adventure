extends HBoxContainer

@onready var player = $"../../World/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(length_of_one())
	self.position.x = player.position.x - size.x/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.global_position.x - self.global_position.x - size.x + length_of_one() > length_of_one():
		self.position.x += length_of_one()
	if player.global_position.x - self.global_position.x - size.x + length_of_one() < length_of_one():
		self.position.x -= length_of_one()
	
		
		

func length_of_one():
	return $TextureRect.size.x*2
