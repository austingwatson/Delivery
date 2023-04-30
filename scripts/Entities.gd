extends Node2D

const goblin_scene = preload("res://scenes/entity/Goblin.tscn")

onready var y_sort = $YSort
var cart = preload("res://scenes/entity/Cart.tscn").instance()


func restart():
	for child in y_sort.get_children():
		if child == cart:
			y_sort.remove_child(child)
		else:
			child.queue_free()
	
	y_sort.add_child(cart)
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
