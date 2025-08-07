extends Control
class_name PauseMenu

@export var hiddenPosition := Vector2(-75, 0.5)
@export var showPosition := Vector2(-6.5, 0.5)
@export var animationDuration : float = 1
@onready var drop_down_menu: BoxContainer = $SuperContainer/Container/DropdownSection/DropDownMenu
@onready var drop_down_button: TextureButton = $SuperContainer/Container/Control/DropDownButton
@onready var container: Control = $SuperContainer/Container
@onready var blur: ColorRect = $Blur
@onready var super_container: GamepadUI = $SuperContainer
@onready var level_name: Label = $"../LevelName"
@onready var canvasLayer : Control = $CanvasLayer/Control

var is_opened := false
var current_tween : Tween
func _ready():
	drop_down_menu.position = hiddenPosition
	Input.joy_connection_changed.connect(on_controller_disconnected)
	
func on_controller_disconnected(device, connected) :
	if device == 0 and not connected : 
		drop_down_button.button_pressed = !drop_down_button.button_pressed
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		drop_down_button.button_pressed = !drop_down_button.button_pressed
	elif Input.is_action_just_pressed("ui_cancel") :
		drop_down_button.button_pressed = false
	if !event is InputEventMouseButton : 
		if !is_opened:
			drop_down_button.set_focus_mode.call_deferred(Control.FOCUS_NONE)
		else :
			drop_down_button.set_focus_mode.call_deferred(Control.FOCUS_ALL)

func set_is_menu_opened(open):
	is_opened = open
	PauseManager.set_paused(open)
	if is_opened : 
		if current_tween : current_tween.kill()
		current_tween = create_tween()
		current_tween.parallel().tween_property(drop_down_menu, "position", showPosition, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(drop_down_button, "rotation_degrees", 360, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(super_container, "position", Vector2(950, 605), animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(super_container, "scale", Vector2.ONE * 3, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(canvasLayer, "modulate", Color(1,1,1,1), animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else : 
		if current_tween : current_tween.kill()
		current_tween = create_tween()
		current_tween.parallel().tween_property(drop_down_menu, "position", hiddenPosition, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(drop_down_button, "rotation_degrees", 0, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished.connect(func() : blur.visible = false)
		current_tween.parallel().tween_property(super_container, "position", Vector2.ZERO, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(super_container, "scale", Vector2.ONE * 1, animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		current_tween.parallel().tween_property(canvasLayer, "modulate", Color(1,1,1,0), animationDuration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _on_quit_button_pressed() -> void:
	if !is_opened : return
	drop_down_button.button_pressed = false
	SceneManager.load_main_menu(Vector2(-1,0))
	HudManager._stop_speedrun_counter()

func _on_restart_button_pressed() -> void:
	if !is_opened : return
	drop_down_button.button_pressed = false
	SceneManager.reset_scene()

func _on_settings_button_pressed() -> void:
	if !is_opened : return
	drop_down_button.button_pressed = false
	SceneManager.load_settings_menu(Vector2(0, -1), false)
	HudManager._stop_speedrun_counter()

func _on_drop_down_button_toggled(toggled_on: bool) -> void:
	set_is_menu_opened(toggled_on)
	is_opened = toggled_on
	PauseManager.set_paused(is_opened)
	if is_opened : 
		super_container.IsMouseControlled = true
		drop_down_button.focus_mode = Control.FOCUS_ALL
		drop_down_button.grab_focus()
		level_name.show_title() 
	else : 
		get_viewport().gui_release_focus()
		drop_down_button.focus_mode = Control.FOCUS_NONE
		level_name.hide_title()
