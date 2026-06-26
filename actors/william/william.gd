extends Area2D

signal tutorial_partes_1
signal tutorial_partes_2
signal tutorial_partes_3

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_partes_1.emit()
