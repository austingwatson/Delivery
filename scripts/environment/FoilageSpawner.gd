extends Node

const foliage_scene = preload("res://scenes/environment/Foliage.tscn")

export var total = 5
export var min_timer = 0.0
export var max_timer = 1.0
export var y_spawn = 100

var objects = []

onready var timer = $Timer


func _ready():
	for i in total:
		var foliage = foliage_scene.instance()
		objects.append(foliage)
		Entities.add_child(foliage)
	
	timer.start(rand_range(min_timer, max_timer))
	
func force_spawn(amount):
	for i in range(min(total, amount)):
		objects[i].enable()
		objects[i].position = Entities.cart.position + Vector2(rand_range(-100, 400), rand_range(-100, 100))


func _on_Timer_timeout():
	for object in objects:
		if not object.in_use:
			object.enable()
			break
	
	timer.start(rand_range(min_timer, max_timer))
