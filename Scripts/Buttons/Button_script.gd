extends BaseButton
class_name ButtonScript
	
func _on_pressed() -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -8, 1)
	focus_mode = FocusMode.FOCUS_NONE
	
func _on_mouse_entered():
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -25, 2)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.0, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
