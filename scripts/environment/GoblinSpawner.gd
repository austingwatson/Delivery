extends Node

export var goblin_total = 5
export var min_timer = 0.0
export var max_timer = 1.0
export var y_spawn = 100

onready var goblin_spawn_timer = $GoblinSpawnTimer


func _ready():
	goblin_spawn_timer.start(rand_range(min_timer, max_timer))


func _on_GoblinSpawnTimer_timeout():
	var goblin_total = get_tree().get_nodes_in_group("Goblin").size()
	if goblin_total > self.goblin_total:
		return
	
	Entities.add_random_goblin(y_spawn)
	goblin_spawn_timer.start(rand_range(min_timer, max_timer))
