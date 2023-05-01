extends Sprite

const frames = [160, 161, 162, 163, 200, 201, 202, 203, 204, 205]

export var min_rock_location = -135.0
export var max_rock_location = 135.0

var in_use = false


func _ready():
	disable()


func _physics_process(_delta):
	if not visible:
		return
	
	if position.x < Entities.cart.position.x - 500:
		disable()
		

func enable():
	visible = true
	in_use = true
	
	var dir = 1
	if SceneManager.cart_direction != Vector2.RIGHT:
		dir = -1
	
	position.x = round(Entities.cart.position.x) + 480.0 * dir
	position.y = round(rand_range(min_rock_location, max_rock_location))
	
	frame = frames[randi() % frames.size()]


func disable():
	visible = false
	in_use = false
