extends Node

const inventory = preload("res://resources/inventory/inventory.tres")
const score = preload("res://resources/score/score.tres")

onready var cart = $Cart
onready var pause_menu = $PauseMenu


func _ready():
	cart.freeze()
	cart.remove_all_cargo()
	
	var wagon_items = inventory.wagon_items
	var last_item = null
	for i in wagon_items.size():
		for j in wagon_items[i].size():
			var item = wagon_items[i][j]
			if item != null and item != last_item:
				remove_item(item)
				last_item = item
			
			wagon_items[i][j] = null
	
	
	var item = inventory.front_items[0]
	remove_item(item)
	item = inventory.front_items[1]
	remove_item(item)
	
	inventory.front_items[0] = null
	inventory.front_items[1] = null


func _unhandled_input(event):
	if event.is_action_released("print_inv"):
		print(inventory.wagon_items)
	
	elif event.is_action_pressed("test_go"):
		SceneManager.change_scene("CityScene")
	
	elif event.is_action_pressed("menu"):
		pause_menu.open_close()
		
	
func remove_item(item):
	if item != null:
		if item.get_type() == 0:
			score.add_to_score(item.info.gold, item.info.stats[0], item.info.stats[1], item.info.stats[2])
			score.print_score()
			item.queue_free()
		elif item.get_type() == 1:
			item.global_position = Vector2(200, rand_range(-100, 100))
			item.visible = true
			add_child(item)

func leave():
	cart.remove_all_cargo()


func _on_WaitTimer_timeout():
	for child in get_children():
		if child.has_method("enable"):
			child.enable()