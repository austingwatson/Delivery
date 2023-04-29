extends Area2D

export var speed = 0.0
export var trail_slowdown = 0.0
export var mud_slowdown = 0.0

var move_up = false
var move_down = false
var shoot = false

var on_trail = true
var mud_count = 0

var archers = []

onready var animation_player = $Sprites/AnimationPlayer


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
	

func _physics_process(delta):
	move(delta)
	

func move(delta):
	var velocity = Vector2.RIGHT
	
	if move_up:
		velocity.y -= 1
	elif move_down:
		velocity.y += 1
	
	# check if out of trail bounds
	if not on_trail:
		velocity *= trail_slowdown
	# check if on mud
	elif mud_count > 0:
		velocity *= mud_slowdown
	
	position += velocity * speed * delta
