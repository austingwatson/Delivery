extends Area2D

const inventory = preload("res://resources/inventory/inventory.tres")

enum State {
	IDLE,
	MOVE,
	TAUNT,
	HURT,
	ACTION,
	DEATH,
}

export var speed = 10.0
export var health = 1

var state = State.IDLE
var in_action_range = false

onready var collision_shape = $CollisionShape2D
onready var animated_sprite = $AnimatedSprite
onready var remove_timer = $RemoveTimer
onready var idle_timer = $IdleTimer
onready var action_shape = $ActionRange/CollisionShape2D


func _ready():
	animated_sprite.play("idle")
	idle_timer.start()


func _physics_process(delta):
	if health <= 0:
		return
	
	if state == State.MOVE:
		move(delta)
	elif state == State.ACTION:
		if global_position.distance_to(Entities.cart.global_position) > 25:
			move(delta)


func move(delta):
	position += position.direction_to(Entities.cart.position) * speed * delta
			
	if global_position.x > Entities.cart.global_position.x:
		animated_sprite.flip_h = false
	elif global_position.x < Entities.cart.global_position.x:
		animated_sprite.flip_h = true
			


func action_done():
	var item = inventory.drop_random_item()
	if item != null:
		item.drop_from_inventory()
		item.global_position = global_position


func damage(amount):
	health -= amount
	if health <= 0:
		action_shape.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", true)
		animated_sprite.play("death")
		state = State.DEATH
		SoundManager.play_goblin_death()
	else:
		animated_sprite.play("hurt")
		state = State.HURT
		SoundManager.play_goblin_hurt()


func _on_AnimatedSprite_animation_finished():
	match state:
		State.DEATH:
			animated_sprite.stop()
			animated_sprite.frame = 6
			remove_timer.start()
		State.HURT:
			animated_sprite.play("idle")
			state = State.IDLE
			idle_timer.start()
		State.TAUNT:
			if in_action_range:
				animated_sprite.play("action")
				state = State.ACTION
			else:
				animated_sprite.play("move")
				state = State.MOVE
		State.ACTION:
			action_done()
			animated_sprite.play("taunt")
			state = State.TAUNT
			SoundManager.play_goblin_laugh()
		
			if global_position.x > Entities.cart.global_position.x:
				animated_sprite.flip_h = false
			elif global_position.x < Entities.cart.global_position.x:
				animated_sprite.flip_h = true


func _on_RemoveTimer_timeout():
	queue_free()


func _on_IdleTimer_timeout():
	var rng = randi() % 2
	if rng == 0:
		animated_sprite.play("move")
		state = State.MOVE
	else:
		animated_sprite.play("taunt")
		state = State.TAUNT
		SoundManager.play_goblin_laugh()
		
		if global_position.x > Entities.cart.global_position.x:
			animated_sprite.flip_h = false
		elif global_position.x < Entities.cart.global_position.x:
			animated_sprite.flip_h = true


func _on_ActionRange_area_entered(_area):
	animated_sprite.play("action")
	state = State.ACTION
	in_action_range = true


func _on_ActionRange_area_exited(_area):
	in_action_range = false
