extends Area2D
@onready var parentBug = get_parent()

func take_damage(dmg):
	parentBug.take_damage(dmg)
