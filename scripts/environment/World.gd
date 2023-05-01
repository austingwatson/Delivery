extends Node2D

onready var trail = $Trail
onready var level_end = $LevelEnd
onready var level_end_timer = $LevelEndTimer
onready var first_marker = $FirstMarker
onready var second_marker = $SecondMarker
onready var last_marker = $LastMarker
onready var foliage_spawner = $FoliageSpawner


func _ready():
	if SceneManager.cart_direction == Vector2.RIGHT:
		level_end.position.x = abs(level_end.position.x)
		first_marker.position.x = level_end.position.x * 0.3
		second_marker.position.x = level_end.position.x * 0.6
		last_marker.position.x = level_end.position.x * 0.9
	else:
		level_end.position.x *= -1
		first_marker.position.x = level_end.position.x * 0.9
		second_marker.position.x = level_end.position.x * 0.6
		last_marker.position.x = level_end.position.x * 0.3
	

func restart():
	foliage_spawner.force_spawn(10)


func _physics_process(_delta):
	trail.position.x = Entities.cart.position.x


func _on_Trail_area_entered(area):
	area.on_trail = true
	SoundManager.loop_wagon_move()


func _on_Trail_area_exited(area):
	area.on_trail = false
	SoundManager.play_wagon_creak()
	SoundManager.stop_wagon_move()


func _on_LevelEnd_area_entered(_area):
	level_end.set_deferred("disabled", true)
	level_end_timer.start()


func _on_LevelEndTimer_timeout():
	if SceneManager.cart_direction == Vector2.RIGHT:
		SceneManager.change_scene("SettlementScene")
	else:
		SceneManager.change_scene("CityScene")
