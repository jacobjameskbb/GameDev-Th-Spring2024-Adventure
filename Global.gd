extends Node

var money = 0
var spawnpoint = Vector2(0,0)
var currect_level = 0

var next_level = {
	0: "res://LEVELS/Level 1 (test).tscn",
	1: "res://LEVELS/Level 2",
	2: "res://LEVELS/Level 3",
	3: "res://LEVELS/Level 4",
	4: "res://LEVELS/Level 5",
	5: "res://LEVELS/Level 6",
	6: "res://LEVELS/Level 7",
	7: "res://LEVELS/Level 8",
	8: "res://LEVELS/boss.tscn",
}

func get_next_level():
	return next_level[currect_level]
