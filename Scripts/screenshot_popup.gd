extends Control
class_name SlidingPopup

@export var hidden_position : Vector2
@export var visible_position : Vector2
@export var time_visible : float = 3
@export var fade_time : float = 1
@onready var label = $Panel/Title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_position(hidden_position)
	visible = false

func activate_popup(text : String, color : Color = Color.WHITE):
	label.text = text
	label.label_settings.font_color = color
	visible = true
	var tweenIn = create_tween()
	tweenIn.tween_property(self, "position", visible_position, fade_time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	
	await tweenIn.finished
	await get_tree().create_timer(time_visible).timeout
	
	var tweenOut = create_tween()
	tweenOut.tween_property(self, "position", hidden_position, fade_time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
