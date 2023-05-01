extends CanvasLayer

onready var label = $Label


func show_tooltip(text):
	label.text = text
	label.visible = true
	

func hide_tooltip():
	label.visible = false
