class_name WorldObjects
extends Resource

export(Array, Resource) var rocks = []
export(Array, Resource) var muds = []


func get_random_rock():
	return rocks[randi() % rocks.size()]
	

func get_random_mud():
	return muds[randi() % muds.size()]
