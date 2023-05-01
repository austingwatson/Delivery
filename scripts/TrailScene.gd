extends Node

onready var pause_menu = $PauseMenu


func _ready():
	Entities.restart()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		pause_menu.open_close()
	

func leave():
	Entities.cart.remove_all_cargo()
	Entities.clear()
