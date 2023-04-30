extends RigidBody2D

const SPRING_CONSTANT = 1000

var mouse_inside = false
var mouse_down = false


func _unhandled_input(event):
	if mouse_inside and event.is_action_pressed("grab"):
		mouse_down = true
	elif event.is_action_released("grab"):
		mouse_down = false


func _physics_process(delta):
	if mouse_down:
		apply_central_impulse(SPRING_CONSTANT * get_local_mouse_position() * delta)
		#rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	var direction = linear_velocity.normalized()
	direction.x *= -1
	direction.y *= -1
	apply_central_impulse(direction)


func _on_Box_mouse_entered():
	mouse_inside = true


func _on_Box_mouse_exited():
	mouse_inside = false
