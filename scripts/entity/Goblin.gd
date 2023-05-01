extends Area2D

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

onready var animated_sprite = $AnimatedSprite
onready var remove_timer = $RemoveTimer
onready var idle_timer = $IdleTimer
onready var attack_range_shape = $AttackRange/CollisionShape2D


func _ready():
	animated_sprite.play("idle")
	idle_timer.start()


func _physics_process(delta):
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
	print("goblin did action")


func damage(amount):
	health -= amount
	if health <= 0:
		animated_sprite.play("death")
		state = State.DEATH
	else:
		animated_sprite.play("hurt")
		state = State.HURT


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
			animated_sprite.play("move")
			state = State.MOVE
			attack_range_shape.set_deferred("disabled", false)
		State.ACTION:
			action_done()
			animated_sprite.play("taunt")
			state = State.TAUNT
		
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
		
		if global_position.x > Entities.cart.global_position.x:
			animated_sprite.flip_h = false
		elif global_position.x < Entities.cart.global_position.x:
			animated_sprite.flip_h = true


func _on_AttackRange_area_entered(area):
	animated_sprite.play("action")
	state = State.ACTION
	attack_range_shape.set_deferred("disabled", true)
