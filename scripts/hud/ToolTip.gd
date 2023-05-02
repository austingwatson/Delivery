extends CanvasLayer

const inventory = preload("res://resources/inventory/inventory.tres")
const score = preload("res://resources/score/score.tres")
const open_color = Color(0.3, 0.21, 0.2)
const full_color = Color(0.77, 0.54, 0.38)
const health_ui_scene = preload("res://scenes/hud/HealthUI.tscn")

signal update_oxen

export var max_health_amount = 10
export var max_oxen = 5

onready var weight_icon = $HBoxContainer/VBoxContainer/Weight
onready var gold_icon = $HBoxContainer/VBoxContainer/Gold
onready var food_icon = $HBoxContainer/VBoxContainer/Food
onready var defense_icon = $HBoxContainer/VBoxContainer/Defense
onready var attack_icon = $HBoxContainer/VBoxContainer/Attack

onready var weight = $HBoxContainer/VBoxContainer/Weight/Label
onready var gold = $HBoxContainer/VBoxContainer/Gold/Label
onready var food = $HBoxContainer/VBoxContainer/Food/Label
onready var defense = $HBoxContainer/VBoxContainer/Defense/Label
onready var attack = $HBoxContainer/VBoxContainer/Attack/Label

onready var wagon = $Wagon
onready var grid = $Wagon/WagonGrid
onready var wagon_front_1 = $Wagon/WagonFront1
onready var wagon_frant_2 = $Wagon/WagonFront2

onready var health = $Health
onready var upgrade = $Upgrades

var max_health = 5
var health_amount = 5


func _ready():
	inventory.connect("item_changed", self, "_on_item_changed")
	
	for i in inventory.current_size.x:
		for j in inventory.current_size.y:
			grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(1)
	
	for i in max_health:
		var health_ui = health_ui_scene.instance()
		health.add_child(health_ui)
	health.set_anchors_preset(Control.PRESET_CENTER_TOP, true)
	health.margin_top = 10
	
	wagon_front_1.color = open_color
	wagon_frant_2.color = open_color
	

func show_wagon():
	wagon.visible = true
	upgrade.visible = true
	health.visible = true
	

func hide_wagon():
	wagon.visible = false
	upgrade.visible = false


func show_tooltip(weight, gold, food, defense, attack):
	self.weight.text = str(weight)
	self.gold.text = str(gold)
	self.food.text = str(food)
	self.defense.text = str(defense)
	self.attack.text = str(attack)
	
	weight_icon.visible = true
	if gold > 0:
		gold_icon.visible = true
	if food > 0:
		food_icon.visible = true
	if defense > 0:
		defense_icon.visible = true
	if attack > 0:
		attack_icon.visible = true
	
func reduce_health():
	health.get_children()[health_amount - 1].visible = false
	health_amount -= 1
	
	if health_amount <= 0:
		SceneManager.change_scene("LoseScene")
		
func show_health():
	health.visible = true


func hide_tooltip():
	weight_icon.visible = false
	gold_icon.visible = false
	food_icon.visible = false
	defense_icon.visible = false
	attack_icon.visible = false
	

func _on_item_changed(side, i, j, full):
	if side == 0:
		if full:
			grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(2)
		else:
			grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(1)
	elif side == 1:
		if i == 0:
			if full:
				wagon_front_1.color = full_color
			else:
				wagon_front_1.color = open_color
		else:
			if full:
				wagon_frant_2.color = full_color
			else:
				wagon_frant_2.color = open_color


func _on_health_button_pressed():
	if score.current_gold < score.health_upg_cost or max_health > max_health_amount:
		return
	else:
		score.current_gold -= score.health_upg_cost
	
	max_health += 1
	health_amount = max_health
	
	if max_health > max_health_amount:
		max_health = max_health_amount
		health_amount = max_health
		return
	
	for child in health.get_children():
		child.queue_free()
	
	for i in max_health:
		var health_ui = health_ui_scene.instance()
		health.add_child(health_ui)
	health.set_anchors_preset(Control.PRESET_CENTER_TOP, true)


func _on_oxen_button_pressed():
	if score.current_gold < score.oxen_upg_cost or inventory.current_oxen > max_oxen:
		return
	else:
		score.current_gold -= score.oxen_upg_cost
	
	inventory.current_oxen += 1
	
	if inventory.current_oxen > max_oxen:
		inventory.current_oxen = max_oxen
		return
	
	emit_signal("update_oxen")


func _on_carry_button_pressed():
	if score.current_gold < score.carry_upg_cost or inventory.current_size.x > 4:
		return
	else:
		score.current_gold -= score.carry_upg_cost
	
	inventory.current_size.x += 1
	inventory.current_size.y += 1
	
	if inventory.current_size.x > 4:
		inventory.current_size.x = 4
		inventory.current_size.y = 4
		return
	
	for i in inventory.current_size.x:
		for j in inventory.current_size.y:
			if grid.get_children()[i * inventory.wagon_items.size() + j].current != 2:
				grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(1)


func _on_speedboost_button_pressed():
	if score.current_gold < score.speed_upg_cost or inventory.has_speed_boost:
		return
	else:
		score.current_gold -= score.speed_upg_cost
	
	inventory.has_speed_boost = true
