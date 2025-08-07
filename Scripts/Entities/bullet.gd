extends Area2D
class_name Bullet

var is_disabled : bool = true
var bullet_speed : float = 100
var bullet_emiter : Object

func _ready() -> void:
	deactivate_bullet()

func activate_bullet(position : Vector2, direction : float, speed : float, emiter):
	global_position = position
	global_rotation = direction
	bullet_speed = speed
	visible = true
	monitorable = true
	monitoring = true
	is_disabled = false
	bullet_emiter = emiter
	
func deactivate_bullet():
	visible = false
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	is_disabled = true
	bullet_emiter = null

func _process(delta: float) -> void:
	if not is_disabled:
		# Move forward along the current rotation
		global_position += Vector2.RIGHT.rotated(global_rotation) * bullet_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is StaticBody2D :
		deactivate_bullet()
	if body is CharacterBody2D :
		if bullet_emiter == null or body != bullet_emiter :
			deactivate_bullet()
			if body is Ghost:
				body._die()
			if body is Player:
				body._die()
