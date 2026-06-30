extends Area2D

signal tutorial_ufrn_1
signal tutorial_ufrn_2

@onready var animation = $OliviaSprite

func _ready() -> void:
	animation.play()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_ufrn_1.emit()
