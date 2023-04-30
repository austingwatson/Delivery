extends Area2D

export var max_size = 10

var size = max_size

onready var trail = $Trail
onready var timer = $Timer


func _ready():
	trail.scale_amount = max_size


func set_direction(velocity):
	var direction = velocity.normalized()
	direction.x *= -1
	direction.y *= -1
	trail.direction = direction


func _on_MudSplat_area_exited(_area):
	trail.emitting = true
	timer.start()


func _on_Timer_timeout():
	trail.scale_amount = size
	size -= 1
	
	if size <= 5:
		trail.emitting = false
		size = max_size
	else:
		timer.start()
