extends Area2D

const world_objects = preload("res://resources/world_objects.tres")

export var min_rock_location = -70.0
export var max_rock_location = 50.0

var in_use = false
var stun_length = 0.0

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite


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
	collision_shape.set_deferred("disabled", false)
	
	var dir = 1
	if SceneManager.cart_direction != Vector2.RIGHT:
		dir = -1
	
	position.x = round(Entities.cart.position.x) + 480.0 * dir
	position.y = round(rand_range(min_rock_location, max_rock_location))
	
	var rock = world_objects.get_random_log()
	sprite.texture = rock.texture
	collision_shape.shape.extents = rock.size / 2
	stun_length = rock.stun_length


func disable():
	visible = false
	in_use = false
	collision_shape.set_deferred("disabled", true)


func _on_Log_area_entered(area):
	area.hit_rock(stun_length)
	disable()
