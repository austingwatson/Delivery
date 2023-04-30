extends Node2D

const arrow_scene = preload("res://scenes/entity/Arrow.tscn")

onready var idle_player = $IdlePlayer
onready var reload_timer = $ReloadTimer

var can_shoot = true


func _ready():
	idle_player.play("forward")
	idle_player.advance(rand_range(0, 1.2))


func shoot(target):
	can_shoot = false
	
	var arrow = arrow_scene.instance()
	Entities.add_to_ysort(arrow)
	arrow.set_velocity(global_position, target)
	reload_timer.start()


func _on_ReloadTimer_timeout():
	can_shoot = true
