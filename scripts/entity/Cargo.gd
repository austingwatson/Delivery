extends RigidBody2D

const cargo_gen = preload("res://resources/cargo/cargo_gen.tres")
const SPRING_CONSTANT = 500
const LIFT_CONSTANT = 2000

var info = {}

var mouse_inside = false
var mouse_down = false
var emit_particle = false

onready var collision_shape = $CollisionShape2D
onready var left_emitter = $LeftEmitter
onready var right_emitter = $RightEmitter
onready var sprite = $Sprite


func _ready():
	info = cargo_gen.gen_info()
	sprite.texture = info.world_texture


func _unhandled_input(event):
	if mouse_inside and event.is_action_pressed("grab"):
		mouse_down = true
		apply_central_impulse(Vector2(0, -LIFT_CONSTANT))
	elif mouse_down and event.is_action_released("grab"):
		mouse_down = false
		apply_central_impulse(Vector2(0, LIFT_CONSTANT))
		emit_particle = true


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
		
		
func set_as_world_object():
	z_index = 1000


func set_as_icon():
	z_index = 0
		

func disable():
	collision_shape.set_deferred("disabled", true)
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	

func enable():
	collision_shape.set_deferred("disabled", false)
	set_deferred("mode", RigidBody2D.MODE_RIGID)
	

func get_size():
	return info.size
	

func get_type():
	return info.type


func _on_Box_mouse_entered():
	mouse_inside = true


func _on_Box_mouse_exited():
	mouse_inside = false
