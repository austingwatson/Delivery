extends TextureRect

export(Texture) var closed
export(Texture) var open
export(Texture) var full


func _ready():
	texture = closed
	

func change_texture(type):
	if type == 0:
		texture = closed
	elif type == 1:
		texture = open
	elif type == 2:
		texture = full
