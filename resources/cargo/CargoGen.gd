class_name CargoGen
extends Resource

export(Array, Resource) var cargos = []

func gen_info():
	var cargo = cargos[randi() % cargos.size()]
	
	var info = {}
	info.size = cargo.size
	info.world_texture = cargo.world_texture
	info.type = cargo.type
	
	return info
