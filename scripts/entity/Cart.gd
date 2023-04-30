extends Area2D

export var max_speed = 0.0
export var trail_slowdown = 0.0
export var mud_slowdown = 0.0
export var min_camera_offset = 100.0
export var max_camera_offset = 100.0

var move_up = false
var move_down = false
var shoot = false
var camera_left = false
var camera_right = false

var speed = 0.0
var on_trail = true
var mud_count = 0
var stunned = false

var archers = []

onready var camera = $Camera2D
onready var sprites = $Sprites
onready var animation_player = $Sprites/AnimationPlayer
onready var flash_timer = $FlashTimer
onready var stun_timer = $StunTimer


func _ready():
	for archer in $Sprites/Archers.get_children():
		archers.append(archer)
	
	animation_player.play("move")


func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		move_up = true
	elif event.is_action_released("move_up"):
		move_up = false
	
	if event.is_action_pressed("move_down"):
		move_down = true
	elif event.is_action_released("move_down"):
		move_down = false
	
	if event.is_action_pressed("shoot"):
		archers.shuffle()
		for archer in archers:
			if archer.can_shoot:
				archer.shoot(get_global_mouse_position())
				break
	
	if event.is_action_pressed("camera_left"):
		camera_left = true
	elif event.is_action_released("camera_left"):
		camera_left = false
	
	if event.is_action_pressed("camera_right"):
		camera_right = true
	elif event.is_action_released("camera_right"):
		camera_right = false
	

func _physics_process(delta):
	move(delta)
	move_camera(delta)
	

func move(delta):
	if stunned:
		return
	
	var velocity = Vector2.RIGHT
	speed = max_speed
	
	if move_up:
		velocity.y -= 1
	elif move_down:
		velocity.y += 1
	
	# check if out of trail bounds
	if not on_trail:
		speed *= trail_slowdown
		animation_player.playback_speed = 1 * trail_slowdown
	# check if on mud
	elif mud_count > 0:
		speed *= mud_slowdown
		animation_player.playback_speed = 1 * mud_slowdown
	else:
		animation_player.playback_speed = 1
	
	position += velocity * speed * delta


func move_camera(delta):
	if stunned:
		return
	
	var dx = 0.0
	if camera_left:
		dx -= 2
	if camera_right:
		dx += 1
		
	camera.offset.x += dx * speed * delta
	if camera.offset.x < min_camera_offset:
		camera.offset.x = min_camera_offset
	elif camera.offset.x > max_camera_offset:
		camera.offset.x = max_camera_offset
	

func hit_rock():
	sprites.material.set_shader_param("flash", true)
	flash_timer.start()
	
	stunned = true
	stun_timer.start()
	animation_player.stop()


func _on_FlashTimer_timeout():
	sprites.material.set_shader_param("flash", false)


func _on_StunTimer_timeout():
	stunned = false
	animation_player.play("move")


func _on_CartContents_body_entered(body):
	print("add: ", body, " to cart")
	body.queue_free()
