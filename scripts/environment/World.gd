extends Node2D

onready var trail = $Trail
onready var level_end = $LevelEnd
onready var level_end_timer = $LevelEndTimer
onready var first_marker = $FirstMarker
onready var second_marker = $SecondMarker
onready var last_marker = $LastMarker
onready var foliage_spawner = $FoliageSpawner
onready var mud_spawner = $MudSpawner
onready var log_spawner = $LogSpawner
onready var rock_spawner = $RockSpawner
onready var stone_wall = $StoneWall
onready var wood_wall = $WoodWall
onready var city_bg = $CityBG
onready var settlement_bg = $SettlementBG


func _ready():
	level_end.position.x += SceneManager.mode * 1000
	
	if SceneManager.cart_direction == Vector2.RIGHT:
		level_end.position.x = abs(level_end.position.x)
		first_marker.position.x = level_end.position.x * 0.3
		second_marker.position.x = level_end.position.x * 0.6
		last_marker.position.x = level_end.position.x * 0.9
		
		stone_wall.position = Vector2(-40, 0)
		wood_wall.position = level_end.position + Vector2(150, 0)
	else:
		level_end.position.x *= -1
		first_marker.position.x = level_end.position.x * 0.9
		second_marker.position.x = level_end.position.x * 0.6
		last_marker.position.x = level_end.position.x * 0.3
		
		stone_wall.position = level_end.position - Vector2(150, 0)
		wood_wall.position = Vector2(-40, 0)
	
	city_bg.position = stone_wall.position
	settlement_bg.position = wood_wall.position
	
	city_bg.visible = true
	settlement_bg.visible = true
	stone_wall.visible = true
	wood_wall.visible = true
	

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
