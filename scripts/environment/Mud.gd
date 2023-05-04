extends Area2D

const world_objects = preload("res://resources/world_objects.tres")

var in_use = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite


func _ready():
	disable()
	

func _physics_process(_delta):
	if not visible:
		return
	
	if position.x - Entities.cart.position.x < -500:
		disable()
		

func enable(y):
	visible = true
	in_use = true
	collision_shape.set_deferred("disabled", false)
	
	var dir = 1
	if SceneManager.cart_direction != Vector2.RIGHT:
		dir = -1
	
	position.x = round(Entities.cart.position.x) + 480.0 * dir
	position.y = y
	
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
