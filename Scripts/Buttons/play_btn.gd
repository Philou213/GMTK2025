extends ButtonScript

func _on_pressed() -> void:
	super()
	SceneManager.load_game(Vector2(0, 1))
