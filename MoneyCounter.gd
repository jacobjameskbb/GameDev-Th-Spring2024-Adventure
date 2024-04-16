extends Node2D

@onready var label_dictionary = {
	'o' : get_node("ones"),
	'o_next' : get_node("ones-switch"),
	't' : get_node("tens"),
	't_next' : get_node("tens"),
	'h' : get_node("hundreds"),
	'h_next' : get_node("hundreds-switch"),
	'T' : get_node("thousands"),
	'T_next' : get_node("thousands-switch"),
	'tT' : get_node("ten-thousands"),
	'tT_next' : get_node('ten-thousands-switch'),
	'hT' : get_node("hundred-thousands"),
	'hT_next' : get_node("hundred-thousands-switch")
}

var number_queue = {
	'hT' : 0,
	'tT' : 0,
	'T' : 0,
	'h' : 0,
	't' : 0,
	'o' : 0,
}

var prev_number_queue = {
	'o' : 0,
	't' : 0,
	'h' : 0,
	'T' : 0,
	'tT' : 0,
	'hT' : 0,
}

var value = 0

var flip_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_counter()

func add(number):
	value += number
	set_number_queue(value)
	
	for place in number_queue:
		if number_queue[place] != prev_number_queue[place]:
			flip_number(place)

	save_old_values()

func save_old_values():
	for place in number_queue:
		prev_number_queue[place] = number_queue[place]

func flip_number(place):
	if $Counter.is_playing() == false:
		$Counter.play_backwards("flip_"+place)
	else:
		flip_queue.append(place)

func set_number_queue(number):
	number_queue['hT'] = floor(number / 100000)
	number = number % 100000
	number_queue['tT'] = floor(number / 10000)
	number = number % 10000
	number_queue['T'] = floor(number / 1000)
	number = number % 1000
	number_queue['h'] = floor(number / 100)
	number = number % 100
	number_queue['t'] = floor(number / 10)
	number = number % 10
	number_queue['o'] = number

func reset_counter():
	for label in label_dictionary:
		label_dictionary[label].play("0")


func _on_counter_animation_finished(_anim_name):
	$Counter.speed_scale = 5 + len(flip_queue) % 10
	
	if len(flip_queue) != 0:
		var flip_place = flip_queue.pop_front()
		label_dictionary[flip_place + '_next'].play(str(number_queue[flip_place]))
		label_dictionary[flip_place].play(str(number_queue[flip_place]))
		$Counter.play_backwards('flip_' + flip_place)

