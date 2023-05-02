extends Node

const inventory = preload("res://resources/inventory/inventory.tres")
const cargo_scene = preload("res://scenes/entity/Cargo.tscn")
const score = preload("res://resources/score/score.tres")

onready var cart = $Cart
onready var pause_menu = $PauseMenu
onready var marker = $Position2D

var mouse_in = false


func _ready():
	cart.freeze()
	cart.remove_all_cargo()
	cart.set_direction(Vector2.RIGHT)
	
	ToolTip.show_gold_ui()

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

	
	ToolTip.show_wagon()
	ToolTip.show_health()
	
	ToolTip.connect("update_oxen", self, "_on_update_oxen")
	
	cart.get_node("Camera2D").offset = Vector2(20, 0)


func remove_item(item):
	if item == null:
		return
	
	if item.get_gold() == 2:
		score.add_gold(2)
		SoundManager.play_coin_sound()
	elif item.get_gold() == 1:
		score.add_gold(1)
		SoundManager.play_coin_sound()
	else:
		item.position = marker.position + Vector2(rand_range(-40, 50), rand_range(-40, 50))
		item.visible = true
		item.enable()
		add_child(item)


func _unhandled_input(event):
	if event.is_action_released("print_inv"):
		print(inventory.wagon_items)
	
	elif event.is_action_pressed("charge"):
		SceneManager.change_scene("TrailScene")
		
	elif event.is_action_pressed("menu"):
		pause_menu.open_close()
		
	elif event.is_action_pressed("inv"):
		ToolTip.show_hide_wagon()
		

func leave():
	ToolTip.hide_wagon()
	cart.remove_all_cargo()
	SceneManager.cart_direction = Vector2.RIGHT


func _on_update_oxen():
	cart.add_ox()


func _on_Area2D_mouse_entered():
	print("mouse in")
	mouse_in = true


func _on_Area2D_mouse_exited():
	print("e")
	mouse_in = false
