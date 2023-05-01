extends Node2D

onready var animation_player = $AnimationPlayer
onready var rope_position = $RopePosition
onready var rope = $Rope
onready var charge_shape = $Charge/CollisionShape2D

func _ready():
	play_anim("move_right")
	rope.add_point(Vector2(0, 0))
	rope.add_point(Vector2(0, 0))
	

func play_anim(anim_name):
	animation_player.play(anim_name)
	
	if anim_name == "move_right" or anim_name == "move_left":
		animation_player.advance(rand_range(0, 0.8))
	elif anim_name == "charge":
		charge_shape.set_deferred("disabled", false)
	

func set_playback_speed(playback_speed):
	animation_player.playback_speed = playback_speed
	

func set_rope(global_position):
	rope.set_point_position(0, global_position - self.global_position)
	rope.set_point_position(1, rope_position.global_position - self.global_position)
	

func freeze():
	if SceneManager.cart_direction == Vector2.RIGHT:
		animation_player.play("move_right")
	else:
		animation_player.play("move_left")
	animation_player.advance(0)
	animation_player.stop()


func stop_charge():
	charge_shape.set_deferred("disabled", true)


func _on_Area2D_area_entered(area):
	area.damage(0)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "charge":
		if SceneManager.cart_direction == Vector2.RIGHT:
			play_anim("move_right")
		else:
			play_anim("move_left")


func _on_Charge_area_entered(area):
	area.disable()
