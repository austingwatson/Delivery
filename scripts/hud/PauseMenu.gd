extends CanvasLayer

onready var music = $VBoxContainer/Music
onready var sound = $VBoxContainer/Sound


func open_close():
	visible = not visible
	
	if visible:
		music.value = AudioServer.get_bus_volume_db(SoundManager.music_db)
		sound.value = AudioServer.get_bus_volume_db(SoundManager.sound_db)


func _on_Resume_pressed():
	visible = false


func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(SoundManager.music_db, value)
	if value == -60:
		AudioServer.set_bus_mute(SoundManager.music_db, true)
	else:
		AudioServer.set_bus_mute(SoundManager.music_db, false)


func _on_Sound_value_changed(value):
	AudioServer.set_bus_volume_db(SoundManager.sound_db, value)
	if value == -60:
		AudioServer.set_bus_mute(SoundManager.sound_db, true)
	else:
		AudioServer.set_bus_mute(SoundManager.sound_db, false)


func _on_Exit_pressed():
	SceneManager.change_scene("MenuScene")
