extends Node2D

@onready var label_dictionary = {
	'o' : get_node("ones"),
	'o_next' : get_node("ones-switch"),
	't' : get_node("tens"),
	't_next' : get_node("tens-switch"),
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
	'hT' : 0,
	'tT' : 0,
	'T' : 0,
	'h' : 0,
	't' : 0,
	'o' : 0,
}

var flip_queue = {
	'o' : 0,
	't' : 0,
	'h' : 0,
	'T' : 0,
	'tT' : 0,
	'hT' : 0,
}

var value = 0

var test_value = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_counter()

func add(number):
	value += number
	
	save_old_values()
	
	set_number_queue(value)
	
	#print(number_queue)
	#print(prev_number_queue)
	
	for place in number_queue:
		if number_queue[place] != prev_number_queue[place]:
			flip_number(place)
	

func save_old_values():
	for place in number_queue:
		prev_number_queue[place] = number_queue[place]

func flip_number(place):
	flip_queue[place] = 1

	if $Counter.is_playing() == false:
		_on_counter_animation_finished("OVERRIDE")


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
	
	$Counter.speed_scale = 5
	
	for place in flip_queue:
		if flip_queue[place] == 1:
			$Counter.speed_scale += 1
	
	if flip_queue['hT'] == 1:
		
		label_dictionary['hT'].play(str(prev_number_queue['hT']))
		label_dictionary['hT_next'].play(str(number_queue['hT']))
		$Counter.play('flip_hT')
		
		flip_queue['hT'] = 0
	
	elif flip_queue['tT'] == 1:
		
		label_dictionary['tT'].play(str(prev_number_queue['tT']))
		label_dictionary['tT_next'].play(str(number_queue['tT']))
		$Counter.play('flip_tT')
		
		flip_queue['tT'] = 0
	
	elif flip_queue['T'] == 1:
		
		label_dictionary['T'].play(str(prev_number_queue['T']))
		label_dictionary['T_next'].play(str(number_queue['T']))
		$Counter.play('flip_T')
		
		flip_queue['T'] = 0
	
	elif flip_queue['h'] == 1:
		
		label_dictionary['h'].play(str(prev_number_queue['h']))
		label_dictionary['h_next'].play(str(number_queue['h']))
		$Counter.play('flip_h')
		
		flip_queue['h'] = 0
	
	elif flip_queue['t'] == 1:
		
		label_dictionary['t'].play(str(prev_number_queue['t']))
		label_dictionary['t_next'].play(str(number_queue['t']))
		$Counter.play('flip_t')
		
		flip_queue['t'] = 0

	elif flip_queue['o'] == 1:
		
		$Counter.speed_scale += 5
		
		label_dictionary['o'].play(str(prev_number_queue['o']))
		label_dictionary['o_next'].play(str(number_queue['o']))
		$Counter.play('flip_o')
		
		flip_queue['o'] = 0

func _process(delta):
	if Global.money > value:
		add(Global.money - value)
