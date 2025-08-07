extends CharacterBody2D
class_name Ghost

@export var SPEED = 300.0
@export var gun_distance := 50.0
@onready var gun : Gun = $Gun
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

var playback: Array = []
var frame_index: int = 0
var is_playing := false
var has_flag : bool = false

func _ready() -> void:
	_die()
	gun.is_ghost = true

func start_replay(data: Array = []):
	if not data.is_empty() : playback = data
	if playback.is_empty() : return
	frame_index = 0
	is_playing = true
	set_physics_process(true)
	collision.set_deferred("disabled", false)
	collision_mask = 1
	collision_layer = 1
	global_position = playback[0]["position"]
	global_rotation = playback[0]["rotation"]
	if playback[0]["shoot"] == true : gun._shoot()
	visible = true
	

func _process(delta):
	if is_playing and frame_index < playback.size():
		var frame = playback[frame_index]
		global_position = frame["position"]
		global_rotation = frame["rotation"]
		if frame["shoot"] == true : gun._shoot()
		if frame["has_flag"] == true : got_flag()
		frame_index += 1
	else:
		is_playing = false
	
func _die():
	is_playing = false
	visible = false
	set_physics_process(false)
	collision.set_deferred("disabled", true)
	collision_layer = 0
	collision_mask = 0
	has_flag = false
	sprite.modulate = Color.ORANGE
	
	
func got_flag():
	has_flag = true
	sprite.modulate = Color.RED
