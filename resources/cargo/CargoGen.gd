class_name CargoGen
extends Resource

export(Array, Resource) var cargos = []
export(Array, Resource) var golds = []

func gen_info(gold):
	var cargo
	if gold == 0:
		cargo = cargos[randi() % cargos.size()]
	elif gold == 3:
		cargo = golds[0]
	else:
		cargo = golds[1]
	
	var info = {}
	info.name = cargo.name
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


func force_archer():
	var cargo = cargos[0]
	var info = {}
	info.name = cargo.name
	info.size = cargo.size
	info.world_texture = cargo.world_texture
	info.type = cargo.type
	info.offset = cargo.offset
	info.stats = [0, 0, 0]
	info.gold = 0
	return info
