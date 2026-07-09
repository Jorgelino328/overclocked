extends TextureRect

@onready var player = get_parent().get_parent()

func _process(_delta) -> void:
	if player.can_dash:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		self_modulate = Color(0.216, 0.161, 0.251, 1.0)
