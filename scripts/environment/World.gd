extends Node2D

onready var trail = $Trail
	

func _physics_process(_delta):
	trail.position.x = Entities.cart.position.x


func _on_Trail_area_entered(area):
	area.on_trail = true


func _on_Trail_area_exited(area):
	area.on_trail = false
