@tool
extends EditorPlugin

### ADD THE MAIN PANEL AND THE PANELS FOR EACH SOUND TYPE

var main_panel : VBoxContainer = null
var music_generator : AudioGenerator = null
var sfx_generator : AudioGenerator = null

func _enter_tree():
	main_panel = VBoxContainer.new()
	main_panel.name = "Audio Tools"
	add_control_to_bottom_panel(main_panel, "Audio Tools")

	var AudioGenerator = preload("res://addons/audio_generator/audio_generator.gd")

	music_generator = AudioGenerator.new()
	music_generator.setup_subpanel(main_panel, "Music")

	sfx_generator = AudioGenerator.new()
	sfx_generator.setup_subpanel(main_panel, "SFX")

func _exit_tree():
	remove_control_from_bottom_panel(main_panel)
	main_panel.queue_free()
