extends Node

const inventory = preload("res://resources/inventory/inventory.tres")
const score = preload("res://resources/score/score.tres")
const cargo_scene = preload("res://scenes/entity/Cargo.tscn")

onready var cart = $Cart
onready var pause_menu = $PauseMenu

onready var food_bar = $ScoreProgress/VBoxContainer/Food
onready var defense_bar = $ScoreProgress/VBoxContainer/Defense
onready var attack_bar = $ScoreProgress/VBoxContainer/Attack
onready var marker = $Position2D


func _ready():
	cart.freeze()
	cart.remove_all_cargo()
	cart.set_direction(Vector2.LEFT)
	
	var wagon_items = inventory.wagon_items
	var last_item = null
	for i in wagon_items.size():
		for j in wagon_items[i].size():
			var item = wagon_items[i][j]
			if item != null and item != last_item:
				remove_item(item)
				last_item = item
			
			inventory.remove_wagon_item(i, j)
	
	
	var item = inventory.front_items[0]
	remove_item(item)
	item = inventory.front_items[1]
	remove_item(item)
	
	inventory.remove_front_item(0)
	inventory.remove_front_item(1)
	
	while score.current_gold > 0:
		if score.current_gold >= 3:
			var rng = rand_range(0, 100)
			if rng < 75:
				var cargo = cargo_scene.instance()
				add_child(cargo)
				cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
				cargo.gen_info(3)
				score.current_gold -= 3
			else:
				var cargo = cargo_scene.instance()
				add_child(cargo)
				cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
				cargo.gen_info(1)
				score.current_gold -= 1
		else:
			var cargo = cargo_scene.instance()
			add_child(cargo)
			cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			cargo.gen_info(1)
			score.current_gold -= 1
			
	var cargo = cargo_scene.instance()
	add_child(cargo)
	cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	cargo.gen_info(3)
	
	cargo = cargo_scene.instance()
	add_child(cargo)
	cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	cargo.gen_info(1)
	
	food_bar.max_value = score.target_food
	defense_bar.max_value = score.target_defense
	attack_bar.max_value = score.target_attack
	
	food_bar.value = score.current_food
	defense_bar.value = score.current_defense
	attack_bar.value = score.current_attack


func _unhandled_input(event):
	if event.is_action_released("print_inv"):
		print(inventory.wagon_items)
		print(inventory.front_items)
	
	elif event.is_action_pressed("charge"):
		SceneManager.change_scene("TrailScene")
	
	elif event.is_action_pressed("menu"):
		pause_menu.open_close()
		
	
func remove_item(item):
	if item != null:
		if item.get_type() == 0:
			score.add_to_score(item.info.gold, item.info.stats[0], item.info.stats[1], item.info.stats[2])
			score.print_score()
			item.queue_free()
		elif item.get_type() == 1:
			print("archer")
			item.global_position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			item.global_position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			item.global_position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			item.visible = true
			add_child(item)

func leave():
	cart.remove_all_cargo()
	SceneManager.cart_direction = Vector2.LEFT


func _on_WaitTimer_timeout():
	for child in get_children():
		if child.has_method("enable"):
			child.enable()
