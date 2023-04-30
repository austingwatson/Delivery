extends Node

onready var menu_scene = preload("res://scenes/MenuScene.tscn").instance()
onready var trail_scene = preload("res://scenes/TrailScene.tscn").instance()
onready var settlement_scene = preload("res://scenes/SettlementScene.tscn").instance()


func _ready():
	add_child(menu_scene)
	

func change_scene(scene_name):
	for child in get_children():
		remove_child(child)
	
	match scene_name:
		"MenuScene":
			add_child(menu_scene)
		"TrailScene":
			add_child(trail_scene)
		"SettlementScene":
			add_child(settlement_scene)
