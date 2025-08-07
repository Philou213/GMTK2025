extends Node2D
class_name Gun

@export var bullet_speed : float = 100
@onready var muzzle : Node2D = $Muzzle
var bullet_pool : BulletPool
var record_shot : bool = false
var is_ghost : bool = false

func _ready() -> void:
	bullet_pool = get_node("../../BulletPool")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot") and not is_ghost:
		SoundManager.play_sound(SFXData.Track.LASERSHOOT,-8)
		_shoot()
		record_shot = true
	
func _shoot():
	var emiter = get_parent()
	var instance : Bullet = bullet_pool.get_instance()
	instance.activate_bullet(muzzle.global_position, muzzle.global_rotation, bullet_speed, emiter)
