# extends Level
extends "res://core/base_classes/level_base.gd" # (Use o caminho que você copiou)

@onready var level_path = "res://levels/testing/level_prototype.tscn"

func level_finish():
	emit_signal("next_level", level_path)


func _on_goal_body_entered(body: Node2D) -> void:
	if body is Player:
		level_finish()


func _on_death_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hp = 0
