extends Node2D

const goblin_scene = preload("res://scenes/entity/Goblin.tscn")

onready var y_sort = $YSort
onready var cart = $YSort/Cart


func restart():
	cart.position = Vector2(0, 0)


func add_to_ysort(entity):
	y_sort.add_child(entity)


func add_random_goblin(y_spawn):
	var goblin = goblin_scene.instance()
	add_to_ysort(goblin)
	goblin.position.x = cart.position.x + rand_range(-240, 480 * 2)
	
	var rng = randi() % 2
	if rng == 0:
		goblin.position.y = y_spawn
	else:
		goblin.position.y = -y_spawn
