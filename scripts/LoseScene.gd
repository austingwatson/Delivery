extends Node

var can_use_input = false


func _unhandled_input(event):
	if not can_use_input:
		return
	
	if event is InputEventKey and event.is_pressed():
		SceneManager.change_scene("MenuScene")


func _on_Timer_timeout():
	can_use_input = true
