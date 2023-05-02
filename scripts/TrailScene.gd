extends Node

onready var pause_menu = $PauseMenu
onready var world = $World


func _ready():
	ToolTip.hide_tooltip()
	
	Entities.restart()
	world.restart()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		pause_menu.open_close()
	

func leave():
	Entities.cart.remove_all_cargo()
	Entities.clear()
