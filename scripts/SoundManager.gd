extends Node

var music_db = 0
var sound_db = 0


func _ready():
	music_db = AudioServer.get_bus_index("Music")
	sound_db = AudioServer.get_bus_index("Sound")
