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
		

func damage(damage):
	#queue_free()
	feathers.direction = Entities.cart.global_position.direction_to(global_position)
	feathers.emitting = true
	
	collision_shape.set_deferred("disabled", true)
	animated_sprite.visible = false
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


func _on_DeathTimer_timeout():
	queue_free()
