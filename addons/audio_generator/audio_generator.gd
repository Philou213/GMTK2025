@tool
extends EditorPlugin
class_name AudioGenerator

### ADD A Panel FOR A AUDIO TYPE

var panel: VBoxContainer
var path_input: LineEdit
var file_dialog: FileDialog
var generator := preload("res://addons/audio_generator/data_generator.gd").new()

var setting_key := ""
var panel_label := ""
var default_path := ""
var output_path := ""
var enum_name := ""
var panel_title := ""
var classname := ""
var dictionary_name := ""

func setup_subpanel(parent: VBoxContainer, base_name: String):
	setup(base_name)
	create_ui(parent)

func setup(base_name: String):
	var lower = base_name.to_lower()
	var upper = base_name.to_upper()

	setting_key  = "audio_generator/%s_path" % lower
	panel_label  = "%s Folder Path:" % base_name
	default_path = "res://Assets/%s/" % base_name
	output_path  = "res://addons/audio_generator/generated/auto_generated_%s.gd" % base_name
	classname    = "%sData" % base_name
	enum_name    = "Track" % base_name
	panel_title  = "%s Tools" % base_name
	dictionary_name = "Audio_Dictionnary" % base_name

func create_ui(parent : VBoxContainer):
	panel = VBoxContainer.new()
	panel.name = panel_title

	var row := HBoxContainer.new()
	panel.add_child(row)

	var label := Label.new()
	label.text = panel_label
	row.add_child(label)

	path_input = LineEdit.new()
	path_input.placeholder_text = default_path
	path_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(path_input)

	var browse_button := Button.new()
	browse_button.text = "Browse"
	browse_button.pressed.connect(_on_browse_pressed)
	row.add_child(browse_button)

	file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.dir_selected.connect(_on_dir_selected)
	panel.add_child(file_dialog)

	var generate_button := Button.new()
	generate_button.text = "Generate Data"
	generate_button.pressed.connect(_on_generate_pressed)
	panel.add_child(generate_button)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	panel.add_child(spacer)

	parent.add_child(panel)

	var saved_path = EditorInterface.get_editor_settings().get_setting(setting_key)
	if saved_path != null : path_input.text = saved_path

func _exit_tree():
	remove_control_from_bottom_panel(panel)
	panel.queue_free()

func _on_browse_pressed():
	file_dialog.popup_centered()

func _on_dir_selected(path: String):
	path_input.text = path

func _on_generate_pressed():
	var path := path_input.text.strip_edges()
	if path == "":
		push_error("No folder selected.")
		return

	EditorInterface.get_editor_settings().set_setting(setting_key, path)

	generator.generate(path, output_path, enum_name, dictionary_name, classname)
