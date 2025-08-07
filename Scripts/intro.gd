extends Node2D

@onready var intro_animation: AnimationPlayer = $IntroAnimation

func _ready() -> void:
	intro_animation.play("Jingle")
	intro_animation.animation_finished.connect(func (_a) : show_main_menu())

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_intro") :
		show_main_menu()

func show_main_menu():
	MusicManager.fade_music_in(MusicData.Track.MUSIC, 1)
	SceneManager.load_main_menu(Vector2(0,1))
	queue_free()
