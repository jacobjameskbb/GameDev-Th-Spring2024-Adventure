
extends Camera2D
var viewport_size

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.global_position = $"..".global_position - Vector2(0,viewport_size.y/14)


