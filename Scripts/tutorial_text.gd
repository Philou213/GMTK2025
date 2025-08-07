extends FloatingUI
class_name TutorialText

var default_text : String
@export_multiline var controller_input := "[img=400][img]"
@export_multiline var mouse_and_keyboard_input := "[img=400][/img]"

func _ready() -> void:
	super._ready()
	default_text = self.text
	InputManager.on_input_type_changed.connect(_on_input_type_changed)
	_set_text(InputManager.current_input_type, InputManager._get_gamepad_type(InputManager.current_gamepad_type))

func _on_input_type_changed(new_input_type : InputManager.INPUT_TYPE, new_gamepad_type : InputManager.GAMEPAD_TYPE):
	_set_text(new_input_type,new_gamepad_type)

func _set_text(input_type : InputManager.INPUT_TYPE, gamepad_type : InputManager.GAMEPAD_TYPE) :
	match input_type:
		InputManager.INPUT_TYPE.KEYBOARD:
			self.text = mouse_and_keyboard_input
	
		InputManager.INPUT_TYPE.GAMEPAD:
			self.text = _get_text_for_gamepad_type(gamepad_type)

func _get_text_for_gamepad_type(new_gamepad_type : InputManager.GAMEPAD_TYPE) -> String :
		var gamepad_type_str : String = InputManager.GAMEPAD_TYPE.keys()[new_gamepad_type]
		
		var raw_text := tr(controller_input)
		var count := raw_text.count("%s")
		var replacements := []
		
		# Add the name of the folder for the gamepad image
		for i in range(count):
			replacements.append(gamepad_type_str)

		return raw_text % replacements
