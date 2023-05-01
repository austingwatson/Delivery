extends Node2D

const goblin_scene = preload("res://scenes/entity/Goblin.tscn")

var cart

onready var y_sort = $YSort


func _physics_process(delta):
	var children = y_sort.get_children()
	
	children.sort_custom(EntitiesSorter, "sort_entities")
	var found_cart = false
	for child in children:
		child.z_index = 2
		if found_cart:
			child.z_index = 25
		elif child == cart:
			found_cart = true
			child.z_index = 10


func restart():
	for child in y_sort.get_children():
		child.queue_free()
	
	cart = preload("res://scenes/entity/Cart.tscn").instance()
	y_sort.add_child(cart)
	cart.position = Vector2(0, 0)
	
	add_random_goblin(100)


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


class EntitiesSorter:
	static func sort_entities(a, b):
		if a.position.y < b.position.y:
			return true
		else:
			return false
			
