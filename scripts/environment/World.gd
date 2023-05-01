extends Node2D

onready var trail = $Trail
onready var level_end = $LevelEnd
onready var level_end_timer = $LevelEndTimer
	

func _physics_process(_delta):
	trail.position.x = Entities.cart.position.x


func _on_Trail_area_entered(area):
	area.on_trail = true


func _on_Trail_area_exited(area):
	area.on_trail = false


func _on_LevelEnd_area_entered(_area):
	level_end.set_deferred("disabled", true)
	level_end_timer.start()


func _on_LevelEndTimer_timeout():
	SceneManager.change_scene("SettlementScene")
