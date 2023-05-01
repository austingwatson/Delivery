extends Node

const chicken_scene = preload("res://scenes/entity/Chicken.tscn")

export var chicken_group = 4
export var min_timer = 0.0
export var max_timer = 1.0
export var y_spawn = 100

onready var timer = $Timer


func _ready():
	timer.start(rand_range(min_timer, max_timer))


func _on_Timer_timeout():
	var chicken_total = get_tree().get_nodes_in_group("Chicken").size()
	if chicken_total > 0:
		return
		
	for i in range(chicken_group):
		var chicken = chicken_scene.instance()
		Entities.add_to_ysort(chicken)
		if SceneManager.cart_direction == Vector2.RIGHT:
			chicken.position = Entities.cart.position + Vector2(480, rand_range(-y_spawn, y_spawn))
		else:
			chicken.position = Entities.cart.position - Vector2(480, rand_range(-y_spawn, y_spawn))
	timer.start(rand_range(min_timer, max_timer))
