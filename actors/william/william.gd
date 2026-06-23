extends Area2D

signal tutorial_2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_2.emit()
