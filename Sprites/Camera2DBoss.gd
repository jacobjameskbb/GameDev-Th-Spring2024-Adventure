
extends Camera2D
var viewport_size
var x_position

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport_rect().size
	x_position = self.global_position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	self.global_position.y = $"..".global_position.y - viewport_size.y/14
	self.global_position.x = x_position
	


