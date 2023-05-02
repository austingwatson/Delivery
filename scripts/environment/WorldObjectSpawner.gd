extends Node

export(Curve) var total
export(Curve) var min_timer
export(Curve) var max_timer
export(int, "Rock", "Mud", "Log") var object_name

var objects = []

onready var spawn_timer = $SpawnTimer


func _ready():
	var total_amount = round(total.interpolate(SceneManager.current_trail))
	for _i in range(total_amount):
		var object
		match object_name:
			0:
				object = preload("res://scenes/environment/Rock.tscn").instance()
			1:
				object = preload("res://scenes/environment/Mud.tscn").instance()
			2:
				object = preload("res://scenes/environment/Log.tscn").instance()
		objects.append(object)
		Entities.add_child(object)
	
	spawn_timer.start(rand_range(min_timer.interpolate(SceneManager.current_trail), max_timer.interpolate(SceneManager.current_trail)))
	

func force_spawn(amount):
	var total_amount = round(total.interpolate(SceneManager.current_trail))
	for i in range(min(total_amount, amount)):
		objects[i].enable()
		objects[i].position = Entities.cart.position + Vector2(rand_range(-100, 400), rand_range(-100, 100))


func _on_SpawnTimer_timeout():
	for object in objects:
		if not object.in_use:
			object.enable()
			break
	
	spawn_timer.start(rand_range(min_timer.interpolate(1.0 - SceneManager.current_trail), max_timer.interpolate(SceneManager.current_trail)))
