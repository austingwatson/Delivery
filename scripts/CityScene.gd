extends Node

const inventory = preload("res://resources/inventory/inventory.tres")

onready var cart = $Cart
onready var pause_menu = $PauseMenu

var mouse_in = false


func _ready():
	cart.freeze()
	
	ToolTip.show_wagon()
	ToolTip.show_health()
	
	ToolTip.connect("update_oxen", self, "_on_update_oxen")


func _unhandled_input(event):
	if event.is_action_released("print_inv"):
		print(inventory.wagon_items)
	
	elif event.is_action_pressed("charge"):
		SceneManager.change_scene("TrailScene")
		
	elif event.is_action_pressed("menu"):
		pause_menu.open_close()
		

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
