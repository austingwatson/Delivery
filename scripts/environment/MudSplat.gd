extends Area2D

export var max_size = 10
export var min_size = 5

var size = max_size
var dont_use = false

onready var trail = $Trail
onready var timer = $Timer


func _ready():
	trail.scale_amount = max_size


func set_direction(velocity):
	var direction = velocity.normalized()
	direction.x *= -1
	direction.y *= -1
	trail.direction = direction
	

func freeze():
	dont_use = true


func _on_MudSplat_area_exited(_area):
	if dont_use:
		return
	
	trail.emitting = true
	timer.start()


func _on_Timer_timeout():
	trail.scale_amount = size
	size -= 1
	
	if size <= min_size:
		trail.emitting = false
		size = max_size
	else:
		timer.start()
