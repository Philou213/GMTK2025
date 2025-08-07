extends Node
class_name BulletPool

@export var pool_size : int = 200

var bullet_object = preload("res://Scenes/Players/bullet.tscn")
var bullet_pool : Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in pool_size:
		var instance : Bullet = bullet_object.instantiate()
		bullet_pool.append(instance)
		add_child(instance)


func get_instance() -> Bullet :
	for bullet : Bullet in bullet_pool:
		if bullet.is_disabled :
			return bullet
	return null  # Optional: create a new bullet here if desired
	
func clear_all_bullets():
	for bullet : Bullet in bullet_pool:
		bullet.deactivate_bullet()
