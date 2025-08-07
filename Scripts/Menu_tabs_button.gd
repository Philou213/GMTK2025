extends Control

@onready var lbIcon : TextureRect = $LBButton
@onready var rbIcon : TextureRect = $RBButton

func _ready() -> void:
	InputManager.on_input_type_changed.connect(_on_input_type_changed)
	_set_icons(InputManager.current_input_type, InputManager._get_gamepad_type(InputManager.current_gamepad_type))

func _on_input_type_changed(new_input_type : InputManager.INPUT_TYPE, new_gamepad_type : InputManager.GAMEPAD_TYPE):
	_set_icons(new_input_type,new_gamepad_type)

func _set_icons(input_type : InputManager.INPUT_TYPE, gamepad_type : InputManager.GAMEPAD_TYPE) :
	match input_type:
		InputManager.INPUT_TYPE.KEYBOARD:
			visible = false
	
		InputManager.INPUT_TYPE.GAMEPAD:
			_set_gamepad_icons(gamepad_type)

func _set_gamepad_icons(new_gamepad_type : InputManager.GAMEPAD_TYPE) :
		var gamepad_type_str : String = InputManager.GAMEPAD_TYPE.keys()[new_gamepad_type]

		lbIcon.texture = load("res://Assets/Sprites/Glyphs/%s/GamepadLB.tres" % gamepad_type_str)
		rbIcon.texture = load("res://Assets/Sprites/Glyphs/%s/GamepadRB.tres" % gamepad_type_str)

		visible = true
