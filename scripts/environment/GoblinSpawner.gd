extends Node

export(Curve) var goblin_total
export(Curve) var min_timer
export(Curve) var max_timer
export var y_spawn = 100
export(Curve) var diff_curve

onready var goblin_spawn_timer = $GoblinSpawnTimer


func _ready():
	goblin_spawn_timer.start(rand_range(min_timer.interpolate(SceneManager.current_trail), max_timer.interpolate(SceneManager.current_trail)))


func _on_GoblinSpawnTimer_timeout():
	var goblin_total = get_tree().get_nodes_in_group("Goblin").size()
	if goblin_total > self.goblin_total.interpolate(SceneManager.current_trail):
		return
	
	Entities.add_random_goblin(y_spawn)
	goblin_spawn_timer.start(rand_range(min_timer, max_timer))
