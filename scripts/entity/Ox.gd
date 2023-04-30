extends Node2D

onready var animation_player = $AnimationPlayer
onready var rope_position = $RopePosition
onready var rope = $Rope

func _ready():
	animation_player.play("move")
	rope.add_point(Vector2(0, 0))
	rope.add_point(Vector2(0, 0))
	

func play_anim(anim_name):
	animation_player.play(anim_name)
	
	if anim_name == "move":
		animation_player.advance(rand_range(0, 0.8))
	

func set_playback_speed(playback_speed):
	animation_player.playback_speed = playback_speed
	

func set_rope(global_position):
	rope.set_point_position(0, global_position - self.global_position)
	rope.set_point_position(1, rope_position.global_position - self.global_position)


func _on_Area2D_area_entered(area):
	area.damage(0)
