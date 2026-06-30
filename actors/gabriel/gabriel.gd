extends Area2D

signal tutorial_mec_1
signal tutorial_mec_2

@onready var animation = $GabrielSprite

func _ready() -> void:
	animation.play()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tutorial_mec_1.emit()
