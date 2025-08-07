extends Node2D
var can_exit := true

func _ready() -> void:
	if get_tree().current_scene == self :
		SceneManager.load_credits_menu.call_deferred(Vector2.ZERO)
		queue_free()

func _on_back_pressed() -> void:
	if can_exit and SceneManager.load_main_menu(Vector2(-1,0)) :
		can_exit = false
