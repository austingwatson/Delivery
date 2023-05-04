extends CanvasLayer

const inventory = preload("res://resources/inventory/inventory.tres")
const score = preload("res://resources/score/score.tres")
const open_color = Color(0.3, 0.21, 0.2)
const full_color = Color(0.77, 0.54, 0.38)
const health_ui_scene = preload("res://scenes/hud/HealthUI.tscn")

signal update_oxen

export var max_health_amount = 10
export var max_oxen = 5

onready var hbox = $HBoxContainer
onready var weight_icon = $HBoxContainer/VBoxContainer/Weight
onready var gold_icon = $HBoxContainer/VBoxContainer/Gold
onready var food_icon = $HBoxContainer/VBoxContainer/Food
onready var defense_icon = $HBoxContainer/VBoxContainer/Defense
onready var attack_icon = $HBoxContainer/VBoxContainer/Attack

onready var stats_bg = $StatsBG
onready var weight = $HBoxContainer/VBoxContainer/Weight/Label
onready var gold = $HBoxContainer/VBoxContainer/Gold/Label
onready var food = $HBoxContainer/VBoxContainer/Food/Label
onready var defense = $HBoxContainer/VBoxContainer/Defense/Label
onready var attack = $HBoxContainer/VBoxContainer/Attack/Label

onready var wagon = $Wagon
onready var grid = $Wagon/WagonGrid
onready var wagon_front_1 = $Wagon/WagonFront1
onready var wagon_front_2 = $Wagon/WagonFront2

onready var health = $Health
onready var upgrade = $Upgrades
onready var health_upg = $Upgrades/Health
onready var oxen_upg = $Upgrades/Oxen
onready var carrr_upg = $Upgrades/Carry
onready var charge_upg = $Upgrades/Charge

onready var gold_bg = $GoldBG
onready var gold_node = $Gold
onready var gold_label = $Gold/Label

var max_health = 5
var health_amount = 5
var tooltip_opposite = false


func _ready():
	inventory.connect("item_changed", self, "_on_item_changed")
	score.connect("gold_changed", self, "_on_gold_changed")
	
	for i in inventory.current_size.x:
		for j in inventory.current_size.y:
			grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(1)
	
	for i in max_health:
		var health_ui = health_ui_scene.instance()
		health.add_child(health_ui)
	health.set_anchors_preset(Control.PRESET_CENTER_TOP, true)
	health.margin_top = 10
	
	wagon_front_1.color = open_color
	

func restart():
	max_health = 5
	health_amount = max_health
	
	health_upg.visible = true
	oxen_upg.visible = true
	carrr_upg.visible = true
	charge_upg.visible = true
	

func show_gold_ui():
	gold_bg.visible = true
	gold_node.visible = true
	

func show_wagon(only_wagon):
	wagon.visible = true
	if not only_wagon:
		upgrade.visible = true
		health.visible = true
	

func hide_wagon():
	wagon.visible = false
	upgrade.visible = false


func show_tooltip(weight, gold, food, defense, attack):
	stats_bg.visible = true
	
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
	
	if tooltip_opposite:
		if stats_bg.get_global_mouse_position().x <= 480 / 2:
			stats_bg.rect_global_position = Vector2(430, 65)
			hbox.rect_global_position = Vector2(450, 84)
		else:
			stats_bg.rect_global_position = Vector2(0, 65)
			hbox.rect_global_position = Vector2(20, 84)
	else:
		stats_bg.rect_global_position = Vector2(430, 65)
		hbox.rect_global_position = Vector2(450, 84)
			
	
func reduce_health():
	health.get_children()[health_amount - 1].visible = false
	health_amount -= 1
	
	if health_amount <= 0:
		SceneManager.change_scene("LoseScene")
		
func show_health():
	health.visible = true
	

func hide_health():
	health.visible = false
	

func heal_to_full():
	health_amount = max_health
	for health in self.get_children():
		health.visible = true
	

func show_hide_gold():
	if gold_node.visible:
		gold_bg.visible = false
		gold_node.visible = false
	else:
		gold_bg.visible = true
		gold_node.visible = true


func hide_gold():
	gold_bg.visible = false
	gold_node.visible = false


func hide_tooltip():
	stats_bg.visible = false
	weight_icon.visible = false
	gold_icon.visible = false
	food_icon.visible = false
	defense_icon.visible = false
	attack_icon.visible = false
	

func show_hide_wagon():
	if wagon.visible:
		hide_wagon()
		health.visible = false
		gold_bg.visible = false
		gold_node.visible = false
	else:
		show_wagon(false)
		health.visible = true
		gold_bg.visible = true
		gold_node.visible = true
	

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
				wagon_front_2.color = full_color
			else:
				wagon_front_2.color = open_color


func _on_gold_changed():
	gold_label.text = str(score.current_gold)


func _on_Health_pressed():
	if score.current_gold < score.health_upg_cost:
		return
	else:
		score.add_gold(-score.health_upg_cost)
	
	max_health += 1
	health_amount = max_health
	
	if max_health >= max_health_amount:
		max_health = max_health_amount
		health_amount = max_health
		health_upg.visible = false
		return
	
	for child in health.get_children():
		child.queue_free()
	
	for i in max_health:
		var health_ui = health_ui_scene.instance()
		health.add_child(health_ui)
	health.set_anchors_preset(Control.PRESET_CENTER_TOP, true)


func _on_Carry_pressed():
	if score.current_gold < score.carry_upg_cost or inventory.current_size.x > 4:
		return
	else:
		score.add_gold(-score.carry_upg_cost)
	
	inventory.current_size.x += 1
	if inventory.current_size.x > 4:
		inventory.current_size.x = 4
		inventory.current_size.y += 1
		
		if inventory.current_size.y > 4:
			inventory.current_size.y = 4
			inventory.front_unlocked = true
			wagon_front_2.color = open_color
	
	for i in inventory.current_size.x:
		for j in inventory.current_size.y:
			if grid.get_children()[i * inventory.wagon_items.size() + j].current != 2:
				grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(1)
	
	if inventory.front_unlocked:
		carrr_upg.visible = false


func _on_Oxen_pressed():
	if score.current_gold < score.oxen_upg_cost or inventory.current_oxen > max_oxen:
		return
	else:
		score.add_gold(-score.oxen_upg_cost)
	
	inventory.current_oxen += 1
	
	if inventory.current_oxen >= max_oxen:
		inventory.current_oxen = max_oxen
		oxen_upg.visible = false
		return
	
	emit_signal("update_oxen")


func _on_Charge_pressed():
	if score.current_gold < score.speed_upg_cost or inventory.has_speed_boost:
		return
	else:
		score.add_gold(-score.speed_upg_cost)
	
	inventory.has_speed_boost = true
	charge_upg.visible = false
