class_name Score
extends Resource

export var target_food = 0
export var target_defense = 0
export var target_attack = 0

var current_gold = 0
var current_food = 0
var current_defense = 0
var current_attack = 0


func add_to_score(gold, food, defense, attack):
	current_gold += gold
	current_food += food
	current_defense += defense
	current_attack += attack
	

func print_score():
	print("Gold: ", current_gold, ", Food: ", current_food, ", Defense: ", current_defense, ", Attack: ", current_attack)
