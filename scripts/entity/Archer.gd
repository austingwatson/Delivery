extends Node2D

const arrow_scene = preload("res://scenes/entity/Arrow.tscn")

onready var idle_player = $IdlePlayer
onready var attack_player = $Attack
onready var body = $Body
onready var bow = $Bow
onready var arrow_spawn_point = $Bow/ArrowSpawnPoint
onready var reload_timer = $ReloadTimer
onready var idle_timer = $IdleTimer

var can_shoot = true
var target = null

var start_position = Vector2.ZERO


func _ready():
	idle_player.play("forward")
	idle_player.advance(rand_range(0, 1.2))


func shoot(target):
	can_shoot = false
	self.target = target
	start_position = arrow_spawn_point.global_position
	
	play_idle(target)
	idle_player.stop()
	
	bow.rotation = global_position.direction_to(target).angle()
	attack_player.play("attack")
	idle_timer.start()


func play_idle(position):
	var current_time = idle_player.current_animation_position
	if position.y >= global_position.y:
		idle_player.play("forward")
	else:
		idle_player.play("backward")
	idle_player.advance(current_time)
	
	flip(position)


func flip(position):
	if position.x >= global_position.x:
		body.flip_h = false
		bow.rotation = 0
	else:
		body.flip_h = true
		bow.rotation = PI


func _on_ReloadTimer_timeout():
	can_shoot = true
	idle_player.play(idle_player.current_animation)
	idle_timer.start()


func _on_Attack_animation_finished(anim_name):
	if anim_name == "attack":
		var arrow = arrow_scene.instance()
		Entities.add_to_ysort(arrow)
		arrow.set_velocity(arrow_spawn_point.global_position, target + (arrow_spawn_point.global_position - start_position))
		target = null
		reload_timer.start()
		
		SoundManager.play_arrow()


func _on_IdleTimer_timeout():
	var rng = randi() % 2
	var current_time = idle_player.current_animation_position
	if rng == 0:
		idle_player.play("forward")
	else:
		idle_player.play("backward")
	idle_player.advance(current_time)
	
	rng = randi() % 2
	if rng == 0:
		body.flip_h = false
		bow.rotation = 0
	else:
		body.flip_h = true
		bow.rotation = PI
	
	idle_timer.start()


func _on_LookArea_area_entered(area):
	if not can_shoot:
		return
	
	play_idle(area.global_position)
	flip(area.global_position)
	idle_timer.start()
