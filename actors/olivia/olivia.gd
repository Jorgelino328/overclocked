extends Area2D

signal tutorial_3

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_3.emit()
