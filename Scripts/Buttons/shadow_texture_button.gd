extends TextureButton
class_name ShadowTextureButton

@export var shadowOffset : Vector2 = Vector2(2,2)
@export var shadowSize : float = 1.02
@export var selectSize : float = 1.2
var shadow : TextureRect

func _ready() -> void:
	pivot_offset = size /2.0
	add_shadow()

func _on_mouse_entered():
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * selectSize, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.0, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_toggled(_toggled_on: bool) -> void:
	SoundManager.play_sound(SFXData.Track.BUTTON_CLICK, -8, 1)
	focus_mode = FocusMode.FOCUS_NONE

func add_shadow():
	shadow = TextureRect.new()
	shadow.texture = texture_normal
	shadow.z_index = -1
	shadow.modulate = Color(0, 0, 0, 1)  # Black
	shadow.position += shadowOffset
	shadow.scale *= shadowSize
	add_child(shadow)
