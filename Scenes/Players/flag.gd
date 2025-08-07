extends Area2D
class_name Flag

func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		SoundManager.play_sound(SFXData.Track.PICKUPCOIN,-6)
		body.capture_flag()
		visible = false
