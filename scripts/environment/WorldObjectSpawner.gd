extends Node

export(Curve) var first_spawn_time
export(Curve) var min_timer
export(Curve) var max_timer
export(int, "Rock", "Mud", "Log") var object_name

var objects = []
var y_spawn: Curve

onready var spawn_timer = $SpawnTimer


func _ready():
	for _i in range(50):
		var object
		match object_name:
			0:
				object = preload("res://scenes/environment/Rock.tscn").instance()
			1:
				object = preload("res://scenes/environment/Mud.tscn").instance()
			2:
				object = preload("res://scenes/environment/Log.tscn").instance()
		objects.append(object)
		
		if object_name == 0:
			Entities.call_deferred("add_to_ysort", object)
		else:
			Entities.add_child(object)
	
	y_spawn = Curve.new()
	y_spawn.min_value = $TopY.position.y
	y_spawn.max_value = $BottomY.position.y
	y_spawn.add_point(Vector2(0.0, y_spawn.min_value))
	y_spawn.add_point(Vector2(1.0, y_spawn.max_value))
	
	spawn_timer.start(first_spawn_time.interpolate(SceneManager.current_trail))


func start_timer():
	var min_time = min_timer.interpolate(SceneManager.current_trail)
	var max_time = max_timer.interpolate(SceneManager.current_trail)
	
	spawn_timer.start(rand_range(min_time, max_time))


func _on_SpawnTimer_timeout():
	for object in objects:
		if not object.in_use:
			var y = y_spawn.interpolate(randf())
			object.enable(y)
			break

	start_timer()
