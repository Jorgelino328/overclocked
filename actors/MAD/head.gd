extends Area2D
@onready var parent = get_parent()

func take_damage(dmg):
	parent.take_damage(dmg)
