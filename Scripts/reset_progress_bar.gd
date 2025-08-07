extends TextureProgressBar

@export var shadowOffset : Vector2 = Vector2(2,2)
@export var shadowSize : float = 1.02
var shadow : TextureRect

func _ready() -> void:
	add_shadow()

func add_shadow():
	shadow = TextureRect.new()
	shadow.texture = texture_under
	shadow.z_index = z_index - 1
	shadow.modulate = Color(0, 0, 0, 1)  # Black
	shadow.position += shadowOffset
	shadow.scale *= shadowSize
	add_child(shadow)
