extends Area2D

const world_objects = preload("res://resources/world_objects.tres")

export var min_rock_location = -100.0
export var max_rock_location = 100.0

var in_use = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite


func _ready():
	disable()


func _physics_process(_delta):
	if not visible:
		return
	
	if position.x < Entities.cart.position.x - 270:
		disable()
		

func enable():
	visible = true
	in_use = true
	collision_shape.set_deferred("disabled", false)
	
	position.x = round(Entities.cart.position.x) + 480.0
	position.y = round(rand_range(min_rock_location, max_rock_location))
	
	var rock = world_objects.get_random_rock()
	sprite.texture = rock.texture
	collision_shape.shape.extents = rock.size / 2


func disable():
	visible = false
	in_use = false
	collision_shape.set_deferred("disabled", true)


func _on_Rock_area_entered(area):
	print(area)
	disable()
