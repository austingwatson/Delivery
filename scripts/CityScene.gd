extends Node

const inventory = preload("res://resources/inventory/inventory.tres")

onready var cart = $Cart


func _ready():
	cart.freeze()


func _unhandled_input(event):
	if event.is_action_released("print_inv"):
		print(inventory.wagon_items)
	
	if event.is_action_pressed("test_go"):
		SceneManager.change_scene("SettlementScene")
		

func leave():
	cart.remove_all_cargo()
