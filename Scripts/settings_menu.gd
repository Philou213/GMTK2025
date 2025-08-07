extends TabContainer
class_name SettingsMenu

@onready var vsyncSlider = $"VIDEO/VIDEO/Items/V-Sync/HSplitContainer/VsyncSlider"
@onready var fullscreenCheckbox : CheckButton = $VIDEO/VIDEO/Items/Fullscreen/HSplitContainer/FullscreenCheckBox
@onready var masterSlider = $AUDIO/AUDIO/Items/Master/HSplitContainer/MasterSlider
@onready var musicSlider = $AUDIO/AUDIO/Items/Music/HSplitContainer/MusicSlider
@onready var sfxSlider = $AUDIO/AUDIO/Items/SFX/HSplitContainer/SFXSlider

@export var popupItemFontSize = 32
@export var popupItemFont : Font
var can_exit := true
var restore_on_exit := false
var exiting := false


static var vsyncModePossible: Dictionary = {
		'DISABLED' : [DisplayServer.VSYNC_DISABLED,""],
		'ENABLED' : [DisplayServer.VSYNC_ENABLED,""],
		'ADAPTIVE' : [DisplayServer.VSYNC_ADAPTIVE, "ADAPTIVE_TOOLTIP"]
		}

signal update_first_input(input : Control)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LeftTab"):
		var newTab : int = current_tab - 1
		if newTab >= 0 : 
			current_tab = newTab
	if Input.is_action_just_pressed("RightTab"):
		var newTab : int = current_tab + 1
		if newTab < get_tab_count() : 
			current_tab = newTab

############Set Focus for Gamepad when switching tabs#####################		
func update_focus():
	var current_container = get_child(current_tab)  # Get the active tab container
	if not current_container:
		return  # Safety check

	var first_focusable : Control = find_focusable(current_container)
	if first_focusable:
		emit_signal("update_first_input", first_focusable)

func find_focusable(node: Node) -> Control:
	for child in node.get_children():
		if child is BaseButton or child is Range:
			return child  # Return the first found focusable node
		var focusable_child = find_focusable(child)  # Recursively check deeper levels
		if focusable_child:
			return focusable_child
	return null  # Return null if no focusable node is found
	
func _on_tab_changed(_tab: int) -> void:
	SoundManager.play_sound(SFXData.Track.TRANSITION, 0)
	update_focus()
	
##############################################################################
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tab_bar().mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	if get_tree().current_scene == get_parent().get_parent() :
		SceneManager.load_settings_menu.call_deferred(Vector2.ZERO)
		get_parent().get_parent().queue_free()
		return
	
	_update_fullscreen_mode()
	addVsyncs()
	update_volume_sliders()
	

	
#Fullscreen------------------------
func _update_fullscreen_mode():
	var fullscreen = SettingsManager._get_display_mode()
	
	if (fullscreen == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN):
		fullscreenCheckbox.button_pressed = true
	else:
		fullscreenCheckbox.button_pressed = false


#VSync------------------------			
func addVsyncs():
	for vsyncMode in vsyncModePossible:
		var vsync_data = vsyncModePossible[vsyncMode]
		var value = vsync_data[0]
		var hint = vsync_data[1]
		vsyncSlider.add_item(vsyncMode, value)
		
		var index = vsyncSlider.get_item_count() - 1
		vsyncSlider.set_item_tooltip(index,hint)
		vsyncSlider.get_item_tooltip(index)
	
	vsyncSlider.get_popup().add_theme_font_size_override("font_size",popupItemFontSize)
	vsyncSlider.get_popup().add_theme_font_override("font",popupItemFont)
	
	_select_vsync_mode()
	
func _select_vsync_mode():
	var currentVsync = SettingsManager._get_vsync_mode()
	# Iterate through the items in the OptionButton
	for i in range(vsyncSlider.item_count):
		if vsyncSlider.get_item_id(i) == currentVsync:
			vsyncSlider.select(i)
			return

#Audio----------------------		
func update_volume_sliders():
	masterSlider.value = SettingsManager.masterVolume
	musicSlider.value = SettingsManager.musicVolume
	sfxSlider.value = SettingsManager.sfxVolume

func _on_vsync_slider_item_selected(index: int) -> void:
	var itemText = vsyncSlider.get_item_text(index)
	var vsyncmode = vsyncModePossible[itemText]
	SettingsManager._update_Vsync_mode(vsyncmode[0])	

func _on_master_slider_value_changed(value: float) -> void:
	SettingsManager._update_master_volume(value)


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager._update_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager._update_sfx_volume(value)


func _on_sfx_slider_drag_ended(_value_changed: bool) -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -8, 1)

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		SettingsManager._update_display_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		SettingsManager._update_display_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
func _on_back_pressed() -> void:
	if restore_on_exit :
		if !exiting :
			HudManager._start_speedrun_counter()
			SceneManager.load_previous_scene()
			exiting = true
	else :
		if !exiting and SceneManager.load_main_menu(Vector2(-1,0)) :
			exiting = true

func _on_tab_hovered():
	CursorManager.set_mouse_cursor(CursorManager.CursorType.CLICK)

func _on_tab_unhovered():
	CursorManager.set_mouse_cursor(CursorManager.CursorType.NORMAL)
