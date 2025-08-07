extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_flag: 
			body.win()
	if body is Ghost:
		if body.has_flag: 
			var player : Player = get_tree().get_first_node_in_group("Player")
			player._die()
