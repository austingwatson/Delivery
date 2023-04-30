extends Area2D

var has_room = true

onready var status = $Status
onready var icon = $Icon


func give_item(texture, slots, dir):
	has_room = false
	#status.texture = status_textures.full
	
	if texture == null:
		return
		
	icon.texture = texture
	
	var midpoint = self.global_position
	for slot in slots:
		if slot == self:
			continue
		else:
			midpoint += slot.global_position
	midpoint /= slots.size()
	
	icon.global_position = midpoint
	icon.visible = true
	#sprite.rotation = dir * (PI / 2)
	#print(sprite.rotation)


func set_yes():
	#status.texture = status_textures.yes
	pass
	

func set_no():
	#status.texture = status_textures.no
	pass


func set_clear():
	#status.texture = null
	pass
