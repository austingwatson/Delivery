extends Node

var cart_direction = Vector2.RIGHT
var current_trail = -0.1
var mode = 0

onready var menu_scene = preload("res://scenes/MenuScene.tscn")
onready var city_scene = preload("res://scenes/CityScene.tscn")
onready var trail_scene = preload("res://scenes/TrailScene.tscn")
onready var settlement_scene = preload("res://scenes/SettlementScene.tscn")
onready var lose_scene = preload("res://scenes/LoseScene.tscn")
onready var win_scene = preload("res://scenes/WinScene.tscn")


func _ready():
	randomize()
	add_child(menu_scene.instance())
	

func change_scene(scene_name):
	for child in get_children():
		if child.has_method("leave"):
			child.leave()
		child.queue_free()
	
	match scene_name:
		"MenuScene":
			call_deferred("add_child", menu_scene.instance())
			current_trail = -0.1 + (mode * 0.4)
		"CityScene":
			add_child(city_scene.instance())
		"TrailScene":
			add_child(trail_scene.instance())
			current_trail += 0.1 + (mode * 0.1)
			if current_trail > 1.0:
				current_trail = 1.0
		"SettlementScene":
			add_child(settlement_scene.instance())
		"LoseScene":
			add_child(lose_scene.instance())
		"WinScene":
			add_child(win_scene.instance())
