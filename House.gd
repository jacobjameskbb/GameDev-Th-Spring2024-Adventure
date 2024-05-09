extends Sprite2D

var MAX_ROTATION = 0.05
var anglesum = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anglesum += delta
	self.rotation = MAX_ROTATION*cos(anglesum)
