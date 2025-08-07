extends ShadowTextureButton

@onready var GamepadIcon : TextureRect = $GamepadIcon

func _ready() -> void:
	GamepadIcon.visible = false
	InputManager.on_input_type_changed.connect(_on_input_type_changed)
	_set_icon(InputManager.current_input_type, InputManager._get_gamepad_type(InputManager.current_gamepad_type))

func _input(_event: InputEvent) -> void:
	if InputManager.is_input_disabled : return
	if Input.is_action_just_pressed("ui_cancel") :
		pressed.emit()		

func _on_pressed() -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -8, 1)
	focus_mode = FocusMode.FOCUS_NONE
	
func _on_input_type_changed(new_input_type : InputManager.INPUT_TYPE, new_gamepad_type : InputManager.GAMEPAD_TYPE):
	_set_icon(new_input_type,new_gamepad_type)

func _set_icon(input_type : InputManager.INPUT_TYPE, gamepad_type : InputManager.GAMEPAD_TYPE) :
	match input_type:
		InputManager.INPUT_TYPE.KEYBOARD:
			GamepadIcon.visible = false
	
		InputManager.INPUT_TYPE.GAMEPAD:
			_set_gamepad_icon(gamepad_type)

func _set_gamepad_icon(new_gamepad_type : InputManager.GAMEPAD_TYPE) :
		var gamepad_type_str : String = InputManager.GAMEPAD_TYPE.keys()[new_gamepad_type]

		GamepadIcon.texture = load("res://Assets/Sprites/Glyphs/%s/GamepadB.tres" % gamepad_type_str)
		GamepadIcon.visible = true

func _on_focus_entered() -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -25, 2)
