extends Camera2D
class_name Camera

static var max_zoom := 2.0
static var min_zoom := 1.0
var pan_tween : Tween
var camera_bounds = Rect2(Vector2(-1280, -720), Vector2(2560, 1440))
var target_position := Vector2.ZERO
		
var target_zoom := Vector2.ONE
var time_since_previous_shake := 0.0
const SPEED := 3
@onready var shake_tween : Tween

func pan(new_position := target_position, new_zoom := target_zoom) :
	if new_zoom.x < min_zoom : new_zoom = Vector2.ONE * min_zoom
	elif new_zoom.x > max_zoom : new_zoom = Vector2.ONE * max_zoom
	target_position = new_position
	target_zoom = new_zoom
	clamp_camera_target()
	
func _process(delta: float) -> void:
	global_position = global_position.move_toward(target_position, global_position.distance_to(target_position) * delta * SPEED)
	zoom = zoom.move_toward(target_zoom, zoom.distance_to(target_zoom) * delta * SPEED)
	time_since_previous_shake += delta

func clamp_camera_target():
	var half_screen_size = (get_viewport_rect().size * 0.5) / target_zoom
	var min_pos = camera_bounds.position + half_screen_size
	var max_pos = camera_bounds.position + camera_bounds.size - half_screen_size
	target_position = target_position.clamp(min_pos, max_pos)

func shake(duration: float, frequency: float, intensity: float) -> void:
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()  # Stop any ongoing shake
	
	var steps := int(duration * frequency)
	var step_duration := duration / steps
	
	shake_tween = create_tween()
	shake_tween.set_parallel(false)
	
	for i in range(steps):
		var shake_offset := Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * intensity
		shake_tween.tween_property(self, "position", shake_offset, step_duration).as_relative()
