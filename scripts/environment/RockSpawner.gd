extends Node

export var rock_total = 5
export var min_rock_timer = 1.0
export var max_rock_timer = 2.0

var rocks = []

onready var rock_spawn_timer = $RockSpawnTimer


func _ready():
	for _i in range(rock_total):
		var rock = preload("res://scenes/environment/Rock.tscn").instance()
		rocks.append(rock)
		Entities.add_child(rock)
	
	rock_spawn_timer.start(rand_range(min_rock_timer, max_rock_timer))


func _on_RockSpawnTimer_timeout():
	for rock in rocks:
		if not rock.in_use:
			rock.enable()
			break

	rock_spawn_timer.start(rand_range(min_rock_timer, max_rock_timer))
