class_name Score
extends Resource

signal won_game
signal gold_changed

export var target_food = 0
export var target_defense = 0
export var target_attack = 0
export var health_upg_cost = 0
export var oxen_upg_cost = 0
export var carry_upg_cost = 0
export var speed_upg_cost = 0

var current_gold = 0
var current_food = 0
var current_defense = 0
var current_attack = 0


func add_to_score(gold, food, defense, attack):
	current_gold += gold
	current_food += food
	current_defense += defense
	current_attack += attack
	
	if current_food >= target_food and current_defense >= target_defense and current_attack >= target_attack:
		SceneManager.change_scene("WinScene")
	
func add_gold(amount):
	current_gold += amount
	emit_signal("gold_changed")


func print_score():
	print("Gold: ", current_gold, ", Food: ", current_food, ", Defense: ", current_defense, ", Attack: ", current_attack)
