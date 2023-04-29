extends Node2D

onready var y_sort = $YSort
onready var cart = $YSort/Cart


func add_to_ysort(entity):
	y_sort.add_child(entity)
