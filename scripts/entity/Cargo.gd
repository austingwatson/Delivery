extends RigidBody2D

const cargo_gen = preload("res://resources/cargo/cargo_gen.tres")
const SPRING_CONSTANT = 500
const LIFT_CONSTANT = 2000

export var force_archer = false

var info = {}

var mouse_inside = false
var mouse_down = false
var emit_particle = false
var tooltip = ""

onready var collision_shape = $CollisionShape2D
onready var left_emitter = $LeftEmitter
onready var right_emitter = $RightEmitter
onready var sprite = $Sprite
onready var coin_timer = $CoinTimer


func _ready():
	if force_archer:
		info = cargo_gen.force_archer()
		setup()
	else:
		gen_info(0)


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
		

func gen_info(gold):
	info = cargo_gen.gen_info(gold)
	setup()

func setup():
	sprite.texture = info.world_texture
	
	tooltip = info.name + "\n" + str(info.size) + "\n" + str(info.gold) + "\n" + str(info.stats[0]) + "\n" + str(info.stats[1]) + "\n" + str(info.stats[2])
	if info.type == 1:
		tooltip = info.name + "\n" + str(info.size)
	
	if info.type == 2:
		sprite.hframes = 40
		sprite.vframes = 22
		sprite.frame = 762
		
		collision_shape.shape.extents = Vector2(6, 6)
	
		right_emitter.position = Vector2(12, 12)
		left_emitter.position = Vector2(-12, 12)
		
		coin_timer.start()
	else:
		collision_shape.shape.extents = sprite.texture.get_size() / 2
		collision_shape.shape.extents.x = max(10, collision_shape.shape.extents.x)
		collision_shape.shape.extents.y = max(10, collision_shape.shape.extents.y)
	
		right_emitter.position = sprite.texture.get_size() / 2
		left_emitter.position = right_emitter.position
		left_emitter.position.x -= sprite.texture.get_size().x


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


func get_offset():
	return info.offset


func _on_Box_mouse_entered():
	mouse_inside = true
	ToolTip.show_tooltip(tooltip)


func _on_Box_mouse_exited():
	mouse_inside = false
	ToolTip.hide_tooltip()


func _on_CoinTimer_timeout():
	sprite.frame += 1
	if sprite.frame > 765:
		sprite.frame = 762
