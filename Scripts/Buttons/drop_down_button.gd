extends ShadowTextureButton
@export var OpenMenuTexture : Texture
@export var CloseMenuTexture : Texture
@onready var GamepadIcon : TextureRect = $GamepadIcon

func _ready() -> void:
	super._ready()
	if CloseMenuTexture == null : printerr("CloseMenuTexture is null")
	if OpenMenuTexture == null : printerr("OpenMenuTexture is null")
	texture_normal = CloseMenuTexture
	shadow.texture = CloseMenuTexture
	GamepadIcon.visible = false
	InputManager.on_input_type_changed.connect(_on_input_type_changed)
	_set_icon(InputManager.current_input_type, InputManager._get_gamepad_type(InputManager.current_gamepad_type))

func _toggled(toggled_on: bool) -> void:
	change_texture(toggled_on)
	
func change_texture(toggled_on : bool):
	if toggled_on : 
		texture_normal = OpenMenuTexture
		shadow.texture = OpenMenuTexture
		GamepadIcon.self_modulate = Color(1,1,1,0)
	else :
		texture_normal = CloseMenuTexture
		shadow.texture = CloseMenuTexture
		GamepadIcon.self_modulate = Color(1,1,1,1)
		
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

		GamepadIcon.texture = load("res://Assets/Sprites/Glyphs/%s/Start.tres" % gamepad_type_str)
		GamepadIcon.visible = true
