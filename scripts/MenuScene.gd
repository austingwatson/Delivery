extends Node

const inventory = preload("res://resources/inventory/inventory.tres")
const score = preload("res://resources/score/score.tres")

var music_started = false

onready var music_slider = $VBoxContainer/Music
onready var sound_slider = $VBoxContainer/Sound


func _ready():
	inventory.restart()
	score.restart()
	ToolTip.restart()
	SoundManager.restart_music()
	
	music_slider.value = AudioServer.get_bus_volume_db(SoundManager.music_db)
	sound_slider.value = AudioServer.get_bus_volume_db(SoundManager.sound_db)


func _input(event):
	if not music_started:
		if event is InputEventKey or event is InputEventMouseButton:
			music_started = true
			SoundManager.play_menu_music()


func leave():
	SceneManager.current_trail = -0.1 + (SceneManager.mode * 0.3)
	score.restart()
	SceneManager.new_game = true


func _on_Play_pressed():
	SceneManager.change_scene("CityScene")


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


func _on_Difficulty_toggled(button_pressed):
	if button_pressed:
		print("set mode to 1")
		SceneManager.mode = 1
	else:
		SceneManager.mode = 0
