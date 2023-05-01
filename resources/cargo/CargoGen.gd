class_name CargoGen
extends Resource

export(Array, Resource) var cargos = []

func gen_info():
	var cargo = cargos[randi() % cargos.size()]
	
	var info = {}
	info.size = cargo.size
	info.world_texture = cargo.world_texture
	info.type = cargo.type
	info.offset = cargo.offset
	
	if cargo.random_stats:
		info.stats = cargo.make_random()
	else:
		info.stats = [cargo.food, cargo.defense, cargo.attack]
	info.gold = cargo.gen_gold(info.stats)
	
	return info
