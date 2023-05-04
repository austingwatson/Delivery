extends Node

const inventory = preload("res://resources/inventory/inventory.tres")
const score = preload("res://resources/score/score.tres")
const cargo_scene = preload("res://scenes/entity/Cargo.tscn")
const chicken_scene = preload("res://scenes/entity/Chicken.tscn")

onready var cart = $Cart
onready var pause_menu = $PauseMenu
onready var marker = $Position2D

onready var score_progress = $ScoreProgress
onready var food_progress = $ScoreProgress/VBoxContainer/Food/Progress
onready var food_label = $ScoreProgress/VBoxContainer/Food/Label
onready var defense_progress = $ScoreProgress/VBoxContainer/Defense/Progress
onready var defense_label = $ScoreProgress/VBoxContainer/Defense/Label
onready var attack_progress = $ScoreProgress/VBoxContainer/Attack/Progress
onready var attack_label = $ScoreProgress/VBoxContainer/Attack/Label
onready var animation_player = $AnimationPlayer

var wagon_shown = true


func _ready():
	SceneManager.cart_direction = Vector2.LEFT
	SoundManager.play_menu_music()
	SoundManager.play_congrats(1)
	
	ToolTip.hide_health()
	ToolTip.show_wagon(true)
	ToolTip.show_gold_ui()
	ToolTip.tooltip_opposite = false
	
	cart.freeze()
	cart.remove_all_cargo()
	cart.set_direction(Vector2.LEFT)
	Entities.cart = cart
	
	var chicken = chicken_scene.instance()
	chicken.position = Vector2(-232, -51)
	Entities.add_to_ysort(chicken)
	
	chicken = chicken_scene.instance()
	chicken.position = Vector2(26, 78)
	Entities.add_to_ysort(chicken)
	
	var gold_total = 0
	var wagon_items = inventory.wagon_items
	var last_item = null
	for i in wagon_items.size():
		for j in wagon_items[i].size():
			var item = wagon_items[i][j]
			if item != null and item != last_item:
				gold_total += remove_item(item)
				last_item = item
			
			inventory.remove_wagon_item(i, j)
	
	
	var item = inventory.front_items[0]
	gold_total += remove_item(item)
	item = inventory.front_items[1]
	gold_total += remove_item(item)
	
	inventory.remove_front_item(0)
	inventory.remove_front_item(1)
	
	#while score.current_gold > 0:
	#	if score.current_gold >= 3:
	#		var rng = rand_range(0, 100)
	#		if rng < 75:
	#			var cargo = cargo_scene.instance()
	#			add_child(cargo)
	#			cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	#			cargo.gen_info(3)
	#			score.current_gold -= 3
	#		else:
	#			var cargo = cargo_scene.instance()
	#			add_child(cargo)
	#			cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	#			cargo.gen_info(1)
	#			score.current_gold -= 1
	#	else:
	#		var cargo = cargo_scene.instance()
	#		add_child(cargo)
	#		cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	#		cargo.gen_info(1)
	#		score.current_gold -= 1
			
	var cargo = cargo_scene.instance()
	add_child(cargo)
	cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	cargo.gen_info(3)
	
	cargo = cargo_scene.instance()
	add_child(cargo)
	cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	cargo.gen_info(1)
	
	while gold_total >= 2:
		cargo = cargo_scene.instance()
		add_child(cargo)
		cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
		cargo.gen_info(3)
		gold_total -= 2
	while gold_total >= 1:
		cargo = cargo_scene.instance()
		add_child(cargo)
		cargo.position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
		cargo.gen_info(1)
		gold_total -= 1
	
	food_progress.max_value = score.target_food
	food_progress.value = score.current_food
	food_label.text = str(min(score.current_food, score.target_food)) + "/" + str(score.target_food)
	
	defense_progress.max_value = score.target_defense
	defense_progress.value = score.current_defense
	defense_label.text = str(min(score.current_defense, score.target_defense)) + "/" + str(score.target_defense)
	
	attack_progress.max_value = score.target_attack
	attack_progress.value = score.current_attack
	attack_label.text = str(min(score.current_attack, score.target_attack)) + "/" + str(score.target_attack)
	
	cart.get_node("Camera2D").offset = Vector2(-75, 0)
	cart.resort_ox()


func _unhandled_input(event):
	if event.is_action_pressed("charge"):
		animation_player.play("cutscene")
	
	elif event.is_action_pressed("menu"):
		pause_menu.open_close()
		
	elif event.is_action_pressed("inv"):
		ToolTip.show_hide_gold()
		score_progress.visible = not score_progress.visible
		if wagon_shown:
			ToolTip.hide_wagon()
			wagon_shown = false
		else:
			ToolTip.show_wagon(true)
			wagon_shown = true
			
func start_cutscene():
	cart.play_anim("move_left")
	cart.get_node("Camera2D").current = false
	ToolTip.hide_wagon()
	ToolTip.hide_gold()
	ToolTip.hide_health()
	score_progress.visible = false
	

func end_cutscene():
	SceneManager.change_scene("TrailScene")
		
	
func remove_item(item):
	var gold_amount = 0
	if item != null:
		if item.get_type() == 0:
			score.add_to_score(0, item.info.stats[0], item.info.stats[1], item.info.stats[2])
			gold_amount = item.get_gold()
			item.queue_free()
		elif item.get_type() == 1:
			item.global_position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			item.global_position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			item.global_position = marker.position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
			item.visible = true
			add_child(item)
	return gold_amount

func leave():
	Entities.clear()
	cart.remove_all_cargo()


func _on_WaitTimer_timeout():
	for child in get_children():
		if child.has_method("enable"):
			child.enable()
