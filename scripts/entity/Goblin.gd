extends Area2D

export var speed = 10.0
export var health = 1


func _physics_process(delta):
	var velocity = position.direction_to(Entities.cart.position) * speed * delta
	position += velocity


func damage(amount):
	health -= amount
	print(health)
	if health <= 0:
		queue_free()
