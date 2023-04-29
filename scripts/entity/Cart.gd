extends KinematicBody2D

export var speed = 0.0
export var world_bounds = 0.0
export var trail_bounds = 0.0
export var trail_slowdown = 0.0
export var mud_slowdown = 0.0

var move_up = false
var move_down = false
var shoot = false

var mud_count = 0

var archers = []


func _ready():
	for archer in $Archers.get_children():
		archers.append(archer)


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
	

func _physics_process(_delta):
	move()
	

func move():
	var velocity = Vector2.RIGHT
	
	if move_up:
		velocity.y -= 1
	elif move_down:
		velocity.y += 1
	
	# check if out of trail bounds
	if position.y >= trail_bounds or position.y <= -trail_bounds:
		velocity.y *= trail_slowdown
		
	# check if on mud
	if mud_count > 0:
		velocity.x *= mud_slowdown
	
	velocity = move_and_slide(velocity * speed)
	
	# check if out of world bounds
	if position.y >= world_bounds:
		position.y = world_bounds
	elif position.y <= -world_bounds:
		position.y = -world_bounds
