extends Node2D
class_name LevelManager
@onready var bulletPool : BulletPool = $BulletPool
@onready var label : Label = $Label
@onready var labelWaves : Label = $LabelWaves
@onready var tutorial : RichTextLabel = $LabelTutorial
@onready var pbLAbel : Label = $PersonalBestLAbel

var waves : int = 1
var labelStatus : int = 0

func _ready():
	var pbScore : int = SaveManager.get_pb()
	pbLAbel.set_text("PB:" + str(pbScore))
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		SceneManager.load_main_menu(Vector2(0,-1))

func _restart():
	active_extract(false)
	set_text_after_win()
	bulletPool.clear_all_bullets()
	loop_all_ghosts()
	_move_player()
	_move_flag()
	
func game_ended():
	SaveManager.set_pb(waves)
	bulletPool.clear_all_bullets()
	var ghosts: Array = []
	for node in get_tree().get_nodes_in_group("Ghost"):
		if node is Ghost:
			node.queue_free()
	SceneManager.reset_scene()

func loop_all_ghosts() -> Array:
	var ghosts: Array = []
	for node in get_tree().get_nodes_in_group("Ghost"):
		if node is Ghost:
			node.start_replay()
	return ghosts

func _move_player():
	var position = random_vector_between(-1200,1200,-650,650)
	var player = get_tree().get_first_node_in_group("Player")
	player.global_position = position
	
func _move_flag():
	var position = random_vector_between_in(-1200,100,-650,650)
	var flag = get_tree().get_first_node_in_group("flag")
	flag.global_position = position
	flag.visible = true
	
	
func random_vector_between(x_min: float, x_max: float, y_min: float, y_max: float) -> Vector2:
	var x: float
	var y: float

	# Regenerate x if it's exactly 0 or 100
	while true:
		x = randf_range(x_min, x_max)
		if x < -800  or x > 800:
			break

	# Regenerate y if it's exactly 0 or 100
	while true:
		y = randf_range(y_min, y_max)
		if y < -500  or y > 500:
			break

	return Vector2(x, y)
	
func random_vector_between_in(x_min: float, x_max: float, y_min: float, y_max: float) -> Vector2:
	var x: float
	var y: float

	# Regenerate x if it's exactly 0 or 100
	while true:
		x = randf_range(x_min, x_max)
		if x > -800 and x < 800:
			break

	# Regenerate y if it's exactly 0 or 100
	while true:
		y = randf_range(y_min, y_max)
		if y > -500  and y < 500:
			break

	return Vector2(x, y)

func add_ghost(recording : Array):
	var ghost = preload("res://Scenes/Players/Ghost.tscn").instantiate()
	ghost.global_position = Vector2(1000,1000)
	add_child(ghost)
	_restart()
	ghost.start_replay(recording.duplicate())


func _on_player_capture_flag_signal() -> void:
	active_extract(true)
	tutorial.visible = false
	if labelStatus == 0:
		label.set_text("Extract at any border")
		labelStatus = 1
		
func set_text_after_win():
	if labelStatus == 1:
		label.set_text("Win before your old versions")
		labelStatus = 2
	elif labelStatus == 2:
		label.visible = false
		labelStatus = 3
	waves += 1
	labelWaves.set_text(str(waves))
	
func active_extract(on : bool) :
	var extracts = get_tree().get_nodes_in_group("Extracts")
	for i in extracts:
		i.set_visible(on)
