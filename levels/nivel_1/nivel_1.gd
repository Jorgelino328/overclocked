# extends Level
extends "res://core/base_classes/level_base.gd" 

@onready var level_path = "res://levels/testing/level_prototype.tscn"
@export var proxima_fase = "res://levels/nivel_2/nivel_2.tscn"

func level_finish():
	emit_signal("level_cleared", proxima_fase)


func _on_goal_body_entered(body: Node2D) -> void:
	if body is Player:
		level_finish()


func _on_death_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hp = 0
