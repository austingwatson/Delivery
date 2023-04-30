extends RigidBody2D

const SPRING_CONSTANT = 500
const LIFT_CONSTANT = 2000

export var inventory_size = Vector2(2, 2)
export(Texture) var icon

var mouse_inside = false
var mouse_down = false
var emit_particle = false

onready var collision_shape = $CollisionShape2D
onready var left_emitter = $LeftEmitter
onready var right_emitter = $RightEmitter
onready var sprite = $Sprite


func _unhandled_input(event):
	if mouse_inside and event.is_action_pressed("grab"):
		mouse_down = true
		apply_central_impulse(Vector2(0, -LIFT_CONSTANT))
		Inventory.current_cargo = self
	elif mouse_down and event.is_action_released("grab"):
		mouse_down = false
		apply_central_impulse(Vector2(0, LIFT_CONSTANT))
		emit_particle = true
		Inventory.close_inventory()


func _physics_process(delta):
	if mouse_down:
		apply_central_impulse(SPRING_CONSTANT * get_local_mouse_position() * delta)
		#rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	var direction = linear_velocity.normalized()
	direction.x *= -1
	direction.y *= -1
	apply_central_impulse(direction)
	
	if emit_particle and linear_velocity.length() < 10:
		emit_particle = false
		left_emitter.emitting = true
		right_emitter.emitting = true
		

func disable():
	mode = RigidBody2D.MODE_KINEMATIC
	

func enable():
	mode = RigidBody2D.MODE_RIGID


func _on_Box_mouse_entered():
	mouse_inside = true


func _on_Box_mouse_exited():
	mouse_inside = false
