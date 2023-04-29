extends CanvasLayer

onready var fps_label = $FPSLabel


func _physics_process(_delta):
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
