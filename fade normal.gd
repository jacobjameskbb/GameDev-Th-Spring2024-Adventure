extends Node2D 

signal finished_fade
@export var speed = 0.1
@export var fade_out_at_start = true
@export var die = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if fade_out_at_start:
		fade_out()
	
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fade():
	while $ColorRect.modulate.a < 1:
		$ColorRect.modulate.a += 0.1 * speed
		await get_tree().create_timer(0.01).timeout
	emit_signal('finished_fade')
	
func fade_out():
	$ColorRect.modulate.a = 1
	while $ColorRect.modulate.a > 0:
		$ColorRect.modulate.a -= 0.1 * speed
		await get_tree().create_timer(0.01).timeout
	emit_signal('finished_fade')
	if die:
		queue_free()
