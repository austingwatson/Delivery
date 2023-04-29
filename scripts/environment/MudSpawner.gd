extends Node

export var mud_total = 5
export var min_mud_timer = 1.0
export var max_mud_timer = 2.0

var muds = []

onready var mud_spawn_timer = $MudSpawnTimer


func _ready():
	for _i in range(mud_total):
		var mud = preload("res://scenes/environment/Mud.tscn").instance()
		muds.append(mud)
		Entities.add_child(mud)
	
	mud_spawn_timer.start(rand_range(min_mud_timer, max_mud_timer))


func _on_MudSpawnTimer_timeout():
	for mud in muds:
		if not mud.in_use:
			mud.enable()
			break
	
	mud_spawn_timer.start(rand_range(min_mud_timer, max_mud_timer))
