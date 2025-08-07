extends Node2D

@export var default_gradient : Gradient
@onready var camera = $Camera
@onready var scene_change_cooldown: Timer = $SceneChangeCooldown
var old_screen : Node2D
var current_screen : Node2D
var current_screen_resource : PackedScene
var default_resolution = Vector2(2560, 1440)
var direction = Vector2(-1, 0)
var transition_speed := 3.0
var previous_scene_zoom := Vector2.ONE
var previous_scene_camera_position := Vector2.ZERO
var previous_screen_resource : PackedScene

const CREDITS = preload("res://Scenes/Menus/Credits.tscn")
const MAIN_MENU = preload("res://Scenes/Menus/MainMenu.tscn")
const SETTINGS = preload("res://Scenes/Menus/SettingsMenu.tscn")
const GAME = preload("res://Scenes/Levels/Default2DLevel.tscn")

func load_game(new_direction := Vector2(1, 0)) -> Node2D:
	var main_menu = load_scene(GAME, new_direction)
	return main_menu
	
func load_main_menu(new_direction := Vector2(1, 0)) -> Node2D:
	var main_menu = load_scene(MAIN_MENU, new_direction)
	return main_menu

func load_credits_menu(new_direction := Vector2(1, 0)) -> Node2D:
	var credits = load_scene(CREDITS, new_direction)
	return credits
	
func load_settings_menu(new_direction := Vector2(1, 0), destroy_old_screen := true) -> Node2D:
	var settings = load_scene(SETTINGS, new_direction, destroy_old_screen)
	return settings
	

func load_scene(scene_resource : Resource, new_direction := Vector2(1, 0), destroy_old_screen := true, allow_same_scene := false, speed := transition_speed) -> Node2D:
	if !scene_change_cooldown.is_stopped() : return null
	if scene_resource == current_screen_resource and !allow_same_scene: return null
	scene_change_cooldown.start()
	if old_screen != null: 
		old_screen.queue_free()
		old_screen = null
	transition_speed = speed
	
	var scene = scene_resource.instantiate()
	
	# Set the starting position of the new screen based on direction
	var new_cam: Camera2D = scene.get_node_or_null("Camera2D")
	var target_camera_zoom : Vector2 = new_cam.zoom if new_cam else camera.target_zoom
	var target_camera_position : Vector2 = new_cam.global_position if new_cam else camera.global_position
	var new_camera_bounds := Rect2(Vector2(-1280, -720) + target_camera_position, Vector2(2560, 1440))
	if new_direction != Vector2.ZERO:
		scene.global_position = new_direction * camera.target_zoom * default_resolution
	else :
		scene.global_position = Vector2.ZERO
		camera.global_position = target_camera_position
		camera.zoom = target_camera_zoom
		camera.camera_bounds = new_camera_bounds
	
	old_screen = current_screen
	current_screen = scene
	
	direction = new_direction  # Update the global direction
	
	add_child(scene)
	
	slide_screens(scene_resource, destroy_old_screen, target_camera_position, target_camera_zoom, new_camera_bounds)
	if new_cam : scene.remove_child(new_cam)
	
	SoundManager.play_sound(SFXData.Track.TRANSITION, 0, transition_speed / 6.0 + (randf() - 0.5) / 4.0)
	
	return scene

func slide_screens(new_screen_resource : PackedScene, destroy_old_screen := true, camera_position := Vector2.ZERO, camera_zoom := Vector2.ONE, camera_bounds := Rect2(Vector2(-1280, -720), Vector2(2560, 1440))):
	camera.camera_bounds = camera_bounds
	camera.pan(camera_position, camera_zoom)
	current_screen.create_tween().tween_property(current_screen, "global_position", Vector2.ZERO, 2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if old_screen :
		var old_screen_tween = old_screen.create_tween().tween_property(old_screen, "global_position", -direction * camera.target_zoom * default_resolution, 2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		if destroy_old_screen : 
			old_screen_tween.finished.connect(
				func () : 
					if old_screen : old_screen.queue_free()
					old_screen = null)
		else:
			previous_screen_resource = current_screen_resource
			previous_scene_zoom = camera.zoom
			previous_scene_camera_position = camera.global_position
	current_screen_resource = new_screen_resource

## Can only be used if load_scene() was called previously with the destroy_old_screen parameter set to false
func load_previous_scene():
	if old_screen :
		var temp := old_screen
		old_screen = current_screen
		current_screen = temp
		direction = - direction
		current_screen_resource = previous_screen_resource
		slide_screens(previous_screen_resource, true, previous_scene_camera_position, previous_scene_zoom)

func reset_scene(reset_direction := Vector2(0, -1)):
	var scene := load_scene(current_screen_resource , reset_direction, true, true)
	if scene :
		return scene
		
	
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

func  _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Fullscreen") :
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN :
			SettingsManager._update_display_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else :
			SettingsManager._update_display_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		#Update the setting if the player is in the settings menu
		if current_screen_resource == SETTINGS:
			var child = current_screen.get_node("Settings/TabContainer")
			if child is SettingsMenu :
				child._update_fullscreen_mode()
