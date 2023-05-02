extends Area2D

enum State {
	IDLE,
	MOVE,
	EAT
}

export var speed = 0.0

var state = State.IDLE
var direction = Vector2.ZERO

onready var collision_shape = $CollisionShape2D
onready var animated_sprite = $AnimatedSprite
onready var feathers = $Feathers


func _ready():
	_on_StateTimer_timeout()


func _physics_process(delta):
	if state == State.MOVE:
		position += direction * speed * delta
		
		#if not is_instance_valid(Entities.cart) or Entities.cart == null:
		#	return
		if global_position.distance_to(Entities.cart.global_position) > 1000:
			queue_free()
		

func damage(damage):
	#queue_free()
	#if not is_instance_valid(Entities.cart) or Entities.cart == null:
	#	return
	
	feathers.direction = Entities.cart.global_position.direction_to(global_position)
	feathers.emitting = true
	
	collision_shape.set_deferred("disabled", true)
	animated_sprite.visible = false
	
	SoundManager.play_chicken_death()
	
	$DeathTimer.start()


func _on_StateTimer_timeout():
	state = randi() % 3
	
	match state:
		State.IDLE:
			animated_sprite.play("idle")
		State.MOVE:
			animated_sprite.play("move")
			direction = position + Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
			direction = position.direction_to(direction)
			
			if direction.x > 0:
				animated_sprite.flip_h = false
			elif direction.x < 0:
				animated_sprite.flip_h = true
		State.EAT:
			animated_sprite.play("eat")
			
			#if not is_instance_valid(Entities.cart) or Entities.cart == null:
			#	SoundManager.play_chicken()
			if global_position.distance_to(Entities.cart.global_position) < 480:
				SoundManager.play_chicken_eat()


func _on_DeathTimer_timeout():
	queue_free()
	

func _on_ChickenSpot_area_exited(area):
	direction = -direction
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
