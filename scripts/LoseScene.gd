extends Node

var can_use_input = false


func _ready():
	ToolTip.hide_gold()
	ToolTip.hide_health()
	ToolTip.hide_tooltip()
	ToolTip.hide_wagon()


func _unhandled_input(event):
	if not can_use_input:
		return
	
	if event is InputEventKey or event is InputEventMouseButton:
		SceneManager.change_scene("MenuScene")


func _on_Timer_timeout():
	can_use_input = true
