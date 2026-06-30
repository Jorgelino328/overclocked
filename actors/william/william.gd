extends Area2D

signal tutorial_partes_1
signal tutorial_partes_2

@onready var animation = $WilliamSprite

func _ready() -> void:
	animation.play()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_partes_1.emit()
