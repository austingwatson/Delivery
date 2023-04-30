extends Node

export var total = 5
export var min_timer = 1.0
export var max_timer = 2.0
export(int, "Rock", "Mud", "Log") var object_name

var objects = []

onready var spawn_timer = $SpawnTimer


func _ready():	
	for _i in range(total):
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
	
	spawn_timer.start(rand_range(min_timer, max_timer))


func _on_SpawnTimer_timeout():
	for object in objects:
		if not object.in_use:
			object.enable()
			break
	
	spawn_timer.start(rand_range(min_timer, max_timer))
