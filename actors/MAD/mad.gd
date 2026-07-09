extends Node2D
@onready var parent_level = get_parent()

var is_active = false

func _process(_delta) -> void:
	is_active = parent_level.is_active
