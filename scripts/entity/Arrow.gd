extends Area2D

export var speed = 10.0
export var max_distance = 100.0
export var damage = 1

var start_position = Vector2.ZERO
var velocity = Vector2.ZERO


func _ready():
	max_distance *= max_distance


func _physics_process(delta):
	position += velocity * delta
	
	if start_position.distance_squared_to(position) > max_distance:
		queue_free()
	
	
func set_velocity(position, target):
	start_position = position
	self.position = position
	velocity = position.direction_to(target) * speed


func _on_Arrow_area_entered(area):
	area.damage(damage)
	queue_free()
