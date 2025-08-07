extends OptionButton

func _ready() -> void:
	var popup = get_popup()
	if popup:
		# Connect the mouse_entered signal of the popup to your method
		popup.mouse_entered.connect(_on_hovered)
		popup.mouse_exited.connect(_on_unhovered)

func _on_pressed() -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -8, 1)

func _on_item_selected(_index: int) -> void:
	_on_pressed()

func _on_hovered():
	CursorManager.set_mouse_cursor(CursorManager.CursorType.CLICK)

func _on_unhovered():
	CursorManager.set_mouse_cursor(CursorManager.CursorType.NORMAL)
