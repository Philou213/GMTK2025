extends Node
var personal_best_score : int = 0

func get_pb() : return personal_best_score

func set_pb(score : int) : 
	if score > personal_best_score:
		personal_best_score = score
