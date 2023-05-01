extends Node

const inventory = preload("res://resources/inventory/inventory.tres")

onready var cart = $Cart
onready var pause_menu = $PauseMenu


func _ready():
	cart.freeze()


func _unhandled_input(event):
	if event.is_action_released("print_inv"):
		print(inventory.wagon_items)
	
	elif event.is_action_pressed("test_go"):
		SceneManager.change_scene("TrailScene")
		
	elif event.is_action_pressed("menu"):
		pause_menu.open_close()
		

func leave():
	cart.remove_all_cargo()
