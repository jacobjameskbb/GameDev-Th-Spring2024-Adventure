extends Node

var volume = 10
var money = 0
var spawnpoint = Vector2(0,0)
var current_level = 0

var next_level = {
	0: "res://LEVELS/Level 1 (test).tscn",
	1: "res://LEVELS/Level 2.tscn",
	2: "res://LEVELS/Level 3.tscn",
	3: "res://LEVELS/Level 4.tscn",
	4: "res://LEVELS/Level 5.tscn",
	5: "res://LEVELS/Level 6.tscn",
	6: "res://LEVELS/Level 7.tscn",
	7: "res://LEVELS/Level 8.tscn",
	8: "res://LEVELS/boss.tscn",
}

func get_next_level():
	current_level += 1
	return next_level[current_level]
	
	
