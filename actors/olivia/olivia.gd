extends Area2D

signal tutorial_ufrn_1
signal tutorial_ufrn_2

@onready var animation = $OliviaSprite
@onready var question = $Question

var is_player_in_area: bool = false
var has_dialogue: bool = false
var tutorial_id = 1

func _ready() -> void:
	animation.play()

func _process(_delta):
	question.visible = has_dialogue
	
	if is_player_in_area and Input.is_action_pressed("interact"):
		if has_dialogue and tutorial_id == 1:
			tutorial_ufrn_1.emit()
			tutorial_id = 2
		elif has_dialogue and tutorial_id == 2:
			tutorial_ufrn_2.emit()
			has_dialogue = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_in_area = true
		

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_in_area = false
