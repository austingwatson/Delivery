class_name Cargo
extends Resource

export var name = ""
export var size = 0
export(Texture) var world_texture
export(int, "world", "human") var type = 0
export var offset = Vector2.ZERO

export var food = 0
export var defense = 0
export var attack = 0
export var max_stats = 0
export var random_stats = false


func make_random():
	if food == 0 or defense == 0 or attack == 0:
		print("bad data: ", name)
		return
	
	var v1 = randi() % food
	var v2 = randi() % defense
	var v3 = randi() % attack
	
	var r1 = v1
	var r2 = min(v2, max_stats - v1)
	var r3 = min(v3, max_stats - v1 - v2)
	return [r1, r2, r3]
