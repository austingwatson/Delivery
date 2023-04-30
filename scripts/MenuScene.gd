extends Node

var music_started = false


func _input(_event):
	if not music_started:
		music_started = true


func _on_Play_pressed():
	SceneManager.change_scene("TrailScene")


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
	get_tree().quit()
