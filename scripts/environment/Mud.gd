extends Area2D

const world_objects = preload("res://resources/world_objects.tres")

export var min_location = -100.0
export var max_location = 100.0

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
	position.y = round(rand_range(min_location, max_location))
	
	var mud = world_objects.get_random_mud()
	sprite.texture = mud.texture
	collision_shape.shape.extents = mud.size / 2


func disable():
	visible = false
	in_use = false
	collision_shape.set_deferred("disabled", true)


func _on_Mud_area_entered(area):
	area.mud_count += 1


func _on_Mud_area_exited(area):
	area.mud_count -= 1
