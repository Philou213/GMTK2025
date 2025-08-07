extends Node

enum CursorType {
	NORMAL,
	CLICK,
	FOCUS,
	DRAG,
}

func _init() -> void:
	init_mouse_cursors()

var cursor_textures: Dictionary = {
	CursorType.NORMAL: preload("res://Assets/Sprites/visor.tres"),
	CursorType.FOCUS: preload("res://Assets/Sprites/visor.tres"),
	CursorType.DRAG: preload("res://Assets/Sprites/visor.tres"),
	CursorType.CLICK: preload("res://Assets/Sprites/visor.tres"),
}

func init_mouse_cursors():
	Input.set_custom_mouse_cursor(cursor_textures[CursorType.NORMAL], Input.CURSOR_ARROW, Vector2i(12, 10))
	Input.set_custom_mouse_cursor(cursor_textures[CursorType.CLICK], Input.CURSOR_POINTING_HAND, Vector2i(12, 10))
	Input.set_custom_mouse_cursor(cursor_textures[CursorType.FOCUS], Input.CURSOR_MOVE, Vector2i(12, 10))
	Input.set_custom_mouse_cursor(cursor_textures[CursorType.DRAG], Input.CURSOR_DRAG, Vector2i(12, 10))

func set_mouse_cursor(cursor_type: CursorType):
	if cursor_textures.has(cursor_type):
		Input.set_custom_mouse_cursor(cursor_textures[cursor_type], Input.CURSOR_ARROW, Vector2i(12, 10))
	
