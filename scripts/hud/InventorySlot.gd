extends Area2D

var has_room = true

onready var sprite = $Sprite


func give_item(texture, slots, dir):
	has_room = false
	sprite.texture = texture
	
	var midpoint = self.global_position
	for slot in slots:
		if slot == self:
			continue
		else:
			midpoint += slot.global_position
	midpoint /= slots.size()
	
	sprite.global_position = midpoint
	sprite.rotation = dir * (PI / 2)
	print(sprite.rotation)
