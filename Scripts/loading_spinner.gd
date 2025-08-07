extends Control
class_name LoadingSpinner

func display_loading():
	visible = true
	InputManager.is_input_disabled = true
	
func hide_loading():
	visible = false
	InputManager.is_input_disabled = false
