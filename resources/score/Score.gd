class_name Score
extends Resource

signal gold_changed

export var target_food = 0
export var target_defense = 0
export var target_attack = 0
export var health_upg_cost = 0
export var oxen_upg_cost = 0
export var carry_upg_cost = 0
export var speed_upg_cost = 0

var won_game = false
var current_gold = 0
var current_food = 0
var current_defense = 0
var current_attack = 0


func restart():
	won_game = false
	current_gold = 0
	current_food = 0
	current_defense = 0
	current_attack = 0
	emit_signal("gold_changed")


func add_to_score(gold, food, defense, attack):
	add_gold(gold)
	current_food += food
	current_defense += defense
	current_attack += attack
	
	if not won_game and current_food >= target_food and current_defense >= target_defense and current_attack >= target_attack:
		won_game = true
		print("win game")
		SceneManager.change_scene("WinScene")
	
func add_gold(amount):
	current_gold += amount
	emit_signal("gold_changed")


func print_score():
	print("Gold: ", current_gold, ", Food: ", current_food, ", Defense: ", current_defense, ", Attack: ", current_attack)
