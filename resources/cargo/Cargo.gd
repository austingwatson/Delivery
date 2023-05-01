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
	
	var v1 = randi() % food + 1
	var v2 = randi() % defense + 1
	var v3 = randi() % attack + 1
	
	var r1 = v1
	var r2 = max(0, min(v2, max_stats - v1))
	var r3 = max(0, min(v3, max_stats - v1 - v2))
	return [r1, r2, r3]


func gen_gold(stats):
	var stat_amount = stats[0] + stats[1] + stats[2]
	
	if size == stat_amount:
		return 1
	elif size > stat_amount:
		return 2
	else:
		return 0
