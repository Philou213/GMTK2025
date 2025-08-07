extends Control
class_name GamepadUI

var IsMouseControlled := true
var Inputs = []
var can_exit := true
@export var FirstControl : Control

func _init():
	call_deferred("_initialize_inputs")
	
func _initialize_inputs():
	_get_focusable_children()
	
func _input(event):
	if InputManager.is_input_disabled : return
	var current_screen : Node2D = SceneManager.current_screen
	if not current_screen or not current_screen.is_ancestor_of(self) : return
	#Mouse inputs
	if event is InputEventJoypadButton or event is InputEventJoypadMotion :
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif event is InputEventMouse :
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	# Check if currently focused control is a TextEdit
	var focused_control = get_viewport().gui_get_focus_owner()
	if focused_control and focused_control is TextEdit:
		# User is typing in a TextEdit; skip focus changes to avoid interrupting input
		return
		
	if (event is InputEventMouseButton) and (event.button_index != MOUSE_BUTTON_WHEEL_DOWN and event.button_index != MOUSE_BUTTON_WHEEL_UP):
		if (!IsMouseControlled): 
			IsMouseControlled = true
			_set_inputs_focus_mode(Control.FOCUS_NONE)
			
	elif !event is InputEventMouseMotion:
		#First key input
		if IsMouseControlled:
			IsMouseControlled = false
			_set_inputs_focus_mode(Control.FOCUS_ALL)
			#Set focus on first control
			if FirstControl:
				_disable_first_controls_focus_neighbors()
				FirstControl.grab_focus()
		#Second key input
		elif FirstControl.has_focus():
				#Allows inputs navigation
				_reset_first_controls_focus_neighbors()
		if get_viewport().gui_get_focus_owner() == null :
			_set_inputs_focus_mode(Control.FOCUS_ALL)
			if FirstControl:
				_disable_first_controls_focus_neighbors()
				FirstControl.grab_focus()
			
func _set_inputs_focus_mode(mode : Control.FocusMode):
	for input in Inputs:
		input.focus_mode = mode

#First input cannot navigate to others inputs
func _disable_first_controls_focus_neighbors():
	FirstControl.focus_neighbor_bottom = FirstControl.get_path()
	FirstControl.focus_neighbor_top	 = FirstControl.get_path()
	FirstControl.focus_neighbor_bottom = FirstControl.get_path()
	FirstControl.focus_neighbor_bottom = FirstControl.get_path()

#Reset the neighbours to the automatics ones of Godot
func _reset_first_controls_focus_neighbors():
	FirstControl.focus_neighbor_bottom = ""
	FirstControl.focus_neighbor_top	 = ""
	FirstControl.focus_neighbor_bottom = ""
	FirstControl.focus_neighbor_bottom = ""
	
func _get_focusable_children():
	var focusable_nodes = []
	_find_focusable_children(self, focusable_nodes)
	Inputs = focusable_nodes
	print("Focusable inputs:", focusable_nodes)

func _find_focusable_children(node, focusable_nodes):
	var children = node.get_children()
	for child in children:
		
		if child is Control and not child.is_visible_in_tree():
			continue
			
		if child.has_method("get_focus_mode") and (child is BaseButton or child is Range):
			focusable_nodes.append(child)
			
		_find_focusable_children(child, focusable_nodes)

func _on_tab_container_update_first_input(input: Control) -> void:
	FirstControl = input
	call_deferred("_initialize_inputs") # Refresh the focusable nodes for the new tab
