extends Control

var default_scale : Vector2
@onready var load_tileset: Button = $LoadTileset
@onready var level_name: Label = $LevelName

func _ready() -> void:
	default_scale = scale * $"../Camera2D".zoom

func _process(delta: float) -> void:
	var target_scale := default_scale / get_viewport().get_camera_2d().zoom
	scale = scale.move_toward(target_scale, abs(scale.x - target_scale.x) * 50.0 * delta)
	
	var cam : Camera2D = get_node_or_null("Camera2D")
	if cam == null : cam = SceneManager.camera
	
	if SceneManager.current_screen == get_parent() : global_position = cam.global_position

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DebugToggle") :
		load_tileset.visible = !load_tileset.visible
