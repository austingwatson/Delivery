extends CanvasLayer

const inventory = preload("res://resources/inventory/inventory.tres")
const open_color = Color(0.3, 0.21, 0.2)
const full_color = Color(0.77, 0.54, 0.38)

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


func _ready():
	inventory.connect("item_changed", self, "_on_item_changed")
	
	for i in inventory.current_size.x:
		for j in inventory.current_size.y:
			grid.get_children()[i * inventory.wagon_items.size() + j].change_texture(1)
	
	wagon_front_1.color = open_color
	wagon_frant_2.color = open_color
	

func show_wagon():
	wagon.visible = true
	

func hide_wagon():
	wagon.visible = false


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
	

func hide_tooltip():
	weight_icon.visible = false
	gold_icon.visible = false
	food_icon.visible = false
	defense_icon.visible = false
	attack_icon.visible = false
	

func _on_item_changed(side, i, j, full):
	print(side)
	print(i)
	print(j)
	print(full)
	print()
	
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
