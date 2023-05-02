extends Area2D

const inventory = preload("res://resources/inventory/inventory.tres")
const archer_scene = preload("res://scenes/entity/Archer.tscn")
const ox_scene = preload("res://scenes/entity/Ox.tscn")

const dirt_color = Color(89.0 / 255.0, 77.0 / 255.0, 77.0 / 255.0)

export var max_speed = 0.0
export var oxen_speed_increase = 0.25
export var max_ox_distance = 8
export var trail_slowdown = 0.0
export var mud_slowdown = 0.0
export var charge_speed = 0.0
export var min_camera_offset = 100.0
export var max_camera_offset = 100.0
export var min_world_height = -100.0
export var max_world_height = 100.0

var move_up = false
var move_down = false
var shoot = false
var camera_left = false
var camera_right = false
var input_blocked = false

var speed = 0.0
var on_trail = true
var mud_count = 0
var stunned = false
var can_charge = true
var charge = false

var archers = []
var ox_distance = 0
var ox_weave = 1
var oxs = []

onready var camera = $Camera2D
onready var sprites = $Sprites
onready var slots = $Sprites/Slots
onready var animation_player = $Sprites/AnimationPlayer
onready var flash_timer = $FlashTimer
onready var stun_timer = $StunTimer
onready var cart_rope_position = $CartRopePosition
onready var oxen = $Oxen
onready var fg_wheel_particles = $Sprites/FGWheelParticle
onready var bg_wheel_particles = $Sprites/BGWheelParticle
onready var charge_timer = $ChargeTimer
onready var charge_cd = $ChargeCD


func _ready():
	populate_wagon()
	
	oxs.append(oxen.get_child(0))
	
	if SceneManager.cart_direction == Vector2.RIGHT:
		animation_player.play("move_right")
		for ox in oxen.get_children():
			ox.play_anim("move_right")
	else:
		animation_player.play("move_left")
		for ox in oxen.get_children():
			ox.play_anim("move_left")
		
		camera.offset.x *= -1
	
	sprites.material.set_shader_param("flash", false)
	
	fg_wheel_particles.color = dirt_color
	bg_wheel_particles.color = dirt_color
	
	if inventory.current_oxen > 1:
		for _i in inventory.current_oxen - 1:
			add_ox()


func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		move_up = true
	elif event.is_action_released("move_up"):
		move_up = false
	
	elif event.is_action_pressed("move_down"):
		move_down = true
	elif event.is_action_released("move_down"):
		move_down = false
	
	elif event.is_action_pressed("shoot"):
		archers.shuffle()
		for archer in archers:
			if archer.can_shoot:
				archer.shoot(get_global_mouse_position())
				break
	
	elif event.is_action_pressed("camera_left"):
		camera_left = true
	elif event.is_action_released("camera_left"):
		camera_left = false
	
	elif event.is_action_pressed("camera_right"):
		camera_right = true
	elif event.is_action_released("camera_right"):
		camera_right = false
		
	elif event.is_action_released("test"):
		add_ox()
		
	elif event.is_action_pressed("charge") and can_charge and inventory.has_speed_boost:
		can_charge = false
		charge = true
		charge_timer.start()
		
		for ox in oxen.get_children():
			ox.play_anim("charge")
		

func _physics_process(delta):
	move(delta)
	move_camera(delta)
	
	for ox in oxen.get_children():
		ox.set_rope(cart_rope_position.global_position)
		

func set_direction(direction):
	pass
		

func populate_wagon():
	var wagon_items = inventory.wagon_items
	var last_item = null
	for i in wagon_items.size():
		for j in wagon_items[i].size():
			if wagon_items[i][j] != null and wagon_items[i][j] != last_item:
				slots.get_children()[i * wagon_items[j].size() + j].add_child(wagon_items[i][j])
				
				if wagon_items[i][j].get_type() == 1:
					var archer = archer_scene.instance()
					slots.get_children()[i * wagon_items[j].size() + j].add_child(archer)
					archer.global_position = slots.get_children()[i * wagon_items[j].size() + j].global_position + wagon_items[i][j].get_offset()
					archers.append(archer)
				
				last_item = wagon_items[i][j]
				
	if inventory.front_items[0] != null:
		slots.get_children()[slots.get_child_count() - 2].add_child(inventory.front_items[0])
		
		if inventory.front_items[0].get_type() == 1:
			var archer = archer_scene.instance()
			slots.get_children()[slots.get_child_count() - 2].add_child(archer)
			archer.global_position = slots.get_children()[slots.get_child_count() - 2].global_position + inventory.front_items[0].get_offset()
			archers.append(archer)
	if inventory.front_items[1] != null:
		slots.get_children()[slots.get_child_count() - 1].add_child(inventory.front_items[1])
		
		if inventory.front_items[1].get_type() == 1:
			var archer = archer_scene.instance()
			slots.get_children()[slots.get_child_count() - 1].add_child(archer)
			archer.global_position = slots.get_children()[slots.get_child_count() - 1].global_position + inventory.front_items[1].get_offset()
			archers.append(archer)
	

func move(delta):
	if stunned:
		return
	
	var velocity = SceneManager.cart_direction
	speed = max_speed
	
	if not input_blocked:
		if move_up:
			velocity.y -= 1
		elif move_down:
			velocity.y += 1
	
	animation_player.playback_speed = 1
	# check if out of trail bounds
	if not on_trail:
		speed *= trail_slowdown
		animation_player.playback_speed *= trail_slowdown
	# check if on mud
	if mud_count > 0:
		speed *= mud_slowdown
		animation_player.playback_speed *= mud_slowdown
	if charge:
		speed *= charge_speed
		animation_player.playback_speed *= charge_speed
		
	for ox in oxen.get_children():
		ox.set_playback_speed(animation_player.playback_speed)
	
	position += velocity * speed * delta
	
	if position.y < min_world_height:
		position.y -= velocity.y * speed * delta
	elif position.y > max_world_height:
		position.y -= velocity.y * speed * delta
	
	oxen.position.y += velocity.y * speed * delta * oxen_speed_increase
	if abs(oxen.global_position.y - global_position.y) > max_ox_distance:
		oxen.position.y -= velocity.y * speed * delta * oxen_speed_increase
	
	if velocity.y == 0 and abs(oxen.position.y) > -2:
		var dy = oxen.position.y - 2
		if dy > 0:
			dy = -1
		elif dy < 0:
			dy = 1
		
		oxen.position.y += dy * speed * delta * oxen_speed_increase
	

func move_camera(delta):
	if input_blocked or stunned:
		return
	
	var dx = 0.0
	if camera_left:
		dx -= 2
	if camera_right:
		dx += 1
		
	camera.offset.x += dx * speed * delta
	if camera.offset.x < min_camera_offset:
		camera.offset.x = min_camera_offset
	elif camera.offset.x > max_camera_offset:
		camera.offset.x = max_camera_offset
		
func remove_archer(side, i, j):
	var child = slots.get_children()[16 + 1 * i]
	for children in child.get_children():
		children.queue_free()
	

func hit_rock():
	sprites.material.set_shader_param("flash", true)
	flash_timer.start()
	
	stunned = true
	stun_timer.start()
	animation_player.stop()
	
	for ox in oxen.get_children():
		ox.play_anim("hurt")
		ox.set_playback_speed(1)
	
	var item = inventory.drop_random_item()
	if item != null:
		item.drop_from_inventory()
		item.global_position = global_position
		

func add_ox():
	ox_distance += 2
	ox_weave *= -1
	
	var ox = ox_scene.instance()
	oxen.call_deferred("add_child", ox)
	ox.position.y = ox_distance * ox_weave
	
	print(oxs)
	oxs.append(ox)
	oxs.sort_custom(OxSorter, "sort_ox")
	
	var dx = 0
	for oxx in oxs:
		oxx.position.x = dx
		dx += 4
		
func freeze():
	set_physics_process(false)
	animation_player.stop()
	for ox in oxen.get_children():
		ox.freeze()
		ox.set_rope(global_position)
	fg_wheel_particles.emitting = false
	bg_wheel_particles.emitting = false
	
	for mudsplat in $MudSplats.get_children():
		mudsplat.freeze()


func set_oxen_x(value):
	oxen.position.x = value


func remove_all_cargo():
	for slot in slots.get_children():
		for slot_child in slot.get_children():
			slot.remove_child(slot_child)
	for archer in archers:
		archer.queue_free()
	archers.clear()


func _on_FlashTimer_timeout():
	sprites.material.set_shader_param("flash", false)


func _on_StunTimer_timeout():
	stunned = false
	if SceneManager.cart_direction == Vector2.RIGHT:
		animation_player.play("move_right")
	else:
		animation_player.play("move_left")
	
	for ox in oxen.get_children():
		if SceneManager.cart_direction == Vector2.RIGHT:
			ox.play_anim("move_right")
		else:
			ox.play_anim("move_left")
		ox.set_playback_speed(animation_player.playback_speed)


func _on_CartContents_body_entered(body):
	var result = inventory.add_next_slot(body)
	
	if not result.empty():
		body.disable()
		body.get_parent().remove_child(body)
		
		var width = result[1]
		var midpoint = Vector2.ZERO
		var children = slots.get_children()
		
		for i in range(2, result.size()):
			midpoint += children[result[0] * width + result[i]].global_position
		midpoint /= result.size() - 2
		
		if width > 10:
			midpoint = slots.get_children()[result[0] * width + result[2]].global_position
		
		midpoint.x = round(midpoint.x)
		midpoint.y = round(midpoint.y)
		
		slots.get_children()[result[0] * width + result[2]].call_deferred("add_child", body)
		body.set_deferred("global_position", midpoint)
		
		if body.get_type() == 0:
			body.set_as_icon()
		elif body.get_type() == 1:
			body.visible = false
			var archer = archer_scene.instance()
			slots.get_children()[result[0] * width + result[2]].call_deferred("add_child", archer)
			archer.set_deferred("global_position", midpoint + body.get_offset())
			archers.append(archer)

class OxSorter:
	static func sort_ox(a, b):
		if a.position.y < b.position.y:
			return true
		else:
			return false


func _on_ChargeTimer_timeout():
	charge = false
	charge_cd.start()
	
	for ox in oxen.get_children():
		ox.stop_charge()


func _on_ChargeCD_timeout():
	can_charge = true
