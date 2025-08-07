extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var gun_distance := 50.0
@onready var gun : Gun = $Gun
@onready var sprite : Sprite2D = $Sprite2D

var recording: Array = []
var is_recording : bool = true
var has_flag : bool = false

signal capture_flag_signal


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left","Right","Up","Down")
	velocity = direction * SPEED

	move_and_slide()

func _process(delta: float) -> void:
	# Get the mouse position in world space
	var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()

	# Calculate the angle from the player to the mouse
	var angle = (mouse_pos - global_position).angle()
	
	global_rotation = angle
	
	if is_recording:
		recording.append({
			"position": global_position,
			"rotation": global_rotation,
			"shoot": gun.record_shot,
			"has_flag" : has_flag
		})
	if gun.record_shot : gun.record_shot = false

func win():
	get_parent().add_ghost(recording)
	recording.clear()
	has_flag = false
	sprite.modulate = Color.BLUE
	
func _die():
	if not visible : return
	visible = false
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	get_parent().game_ended()
	
func capture_flag():
	has_flag = true
	sprite.modulate = Color.GREEN
	emit_signal("capture_flag_signal")
	
	
