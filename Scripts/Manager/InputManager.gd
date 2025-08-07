extends Node

static var is_input_disabled : bool = false
static var current_input_type : INPUT_TYPE = INPUT_TYPE.KEYBOARD
static var current_gamepad_type : GAMEPAD_TYPE = GAMEPAD_TYPE.AUTOMATIC
static var gamepad_sensitivity : float = 80
static var double_click_threshold : float = 0.25

signal on_input_type_changed(new_input_type : INPUT_TYPE, new_gamepad_type : GAMEPAD_TYPE)

enum INPUT_TYPE {
	GAMEPAD,
	KEYBOARD,
} 

enum GAMEPAD_TYPE {
	AUTOMATIC,
	NINTENDO,
	PLAYSTATION,
	XBOX
}

func _input(event: InputEvent) -> void:
	_set_new_input_type(event)
		
static func _set_new_input_type(event: InputEvent) :
	var new_input_type : INPUT_TYPE = current_input_type
	var new_gamepad_type : GAMEPAD_TYPE = current_gamepad_type
	
	# Detect input source
	if event is InputEventKey or event is InputEventMouseButton :
		new_input_type = INPUT_TYPE.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion :
		new_input_type = INPUT_TYPE.GAMEPAD
		new_gamepad_type = _get_gamepad_type(current_gamepad_type)
		
	# Emit signal if the input type has changed
	if new_input_type != current_input_type || new_gamepad_type != current_gamepad_type:	
		InputManager.emit_signal("on_input_type_changed", new_input_type, new_gamepad_type)
	
	# Save the new values
	current_input_type = new_input_type

# Returns the actual gamepad type based on connected devices or a manual setting
static func _get_gamepad_type(gamepad_type : GAMEPAD_TYPE) -> GAMEPAD_TYPE:
	# Get the automatic gamepad type (Check for the first gamepad's type
	if gamepad_type == GAMEPAD_TYPE.AUTOMATIC :
		var connected_devices = Input.get_connected_joypads()
		
		if connected_devices.size() > 0 :
			var device_id : int = connected_devices.get(0)
			var device_name : String = Input.get_joy_name(device_id)
			
			if device_name.contains("PS") : return GAMEPAD_TYPE.PLAYSTATION
			if device_name.contains("Nintendo") : return GAMEPAD_TYPE.NINTENDO
		return GAMEPAD_TYPE.XBOX
	# Return the gamepad type set by the player
	else : return gamepad_type
	
# Custom setter for the gamepad type
static func set_gamepad_type(gamepad_type_index : int) -> void:
	# Get the schema (useful if automatic)
	var new_gamepad_type = _get_gamepad_type(gamepad_type_index)
	
	# Set to the value chosen by the player
	current_gamepad_type = gamepad_type_index
	
	# Emit signal if using gamepad
	if current_input_type == INPUT_TYPE.GAMEPAD:
		InputManager.emit_signal("on_input_type_changed", current_input_type, new_gamepad_type)
		
static func is_using_mouse() -> bool :
	return current_input_type == INPUT_TYPE.KEYBOARD
