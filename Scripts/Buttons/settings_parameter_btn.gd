extends Control
	
func _on_pressed() -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -8, 1)

func _on_item_selected(_index: int) -> void:
	_on_pressed()
