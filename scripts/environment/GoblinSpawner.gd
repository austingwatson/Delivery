extends Node

export(Curve) var goblin_total
export(Curve) var first_goblin_time
export(Curve) var min_timer
export(Curve) var max_timer
export(Curve) var goblin_spawn_amount
export var y_spawn = 100

onready var goblin_spawn_timer = $GoblinSpawnTimer


func _ready():
	goblin_spawn_timer.start(first_goblin_time.interpolate(SceneManager.current_trail))


func start_timer():
	var min_time = min_timer.interpolate(SceneManager.current_trail)
	var max_time = max_timer.interpolate(SceneManager.current_trail)
	
	goblin_spawn_timer.start(rand_range(min_time, max_time))


func _on_GoblinSpawnTimer_timeout():
	var goblin_total = get_tree().get_nodes_in_group("Goblin").size()
	
	print("goblin total in world: ", goblin_total)
	
	goblin_total = self.goblin_total.interpolate(SceneManager.current_trail) - goblin_total
	var amount = min(goblin_total, round(goblin_spawn_amount.interpolate(SceneManager.current_trail)))
	
	print("goblins to spawn: ", amount)
	
	for i in range(amount):
		Entities.add_random_goblin(y_spawn)
	start_timer()
