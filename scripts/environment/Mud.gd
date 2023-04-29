extends Area2D

export var min_location = -100.0
export var max_location = 100.0

var in_use = false

onready var collision_shape = $CollisionShape2D


func _ready():
	disable()


func _physics_process(_delta):
	if not visible:
		return
	
	if position.x < Entities.cart.position.x - 200:
		disable()
		

func enable():
	visible = true
	in_use = true
	collision_shape.set_deferred("disabled", false)
	position.x = Entities.cart.position.x + 480.0
	position.y = rand_range(min_location, max_location)


func disable():
	visible = false
	in_use = false
	collision_shape.set_deferred("disabled", true)


func _on_Mud_body_entered(body):
	body.mud_count += 1


func _on_Mud_body_exited(body):
	body.mud_count -= 1
