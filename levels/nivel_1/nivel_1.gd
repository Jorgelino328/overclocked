extends Level

@onready var level_path = "res://levels/testing/level_prototype.tscn"
@export var proxima_fase = "res://levels/nivel_2/nivel_2.tscn"
@export var music = preload("res://assets/audio/music/lab.ogg")

var psu_dialogue = "res://assets/dialogue/psu_dialogue.json"

func level_finish():
	emit_signal("level_cleared", proxima_fase)


func _on_goal_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_psu:
			level_finish()
		else:
			var dialogue_instance = dialogueUI.instantiate()
			dialogue_instance.dialoguePath = psu_dialogue
			add_child(dialogue_instance)


func _on_death_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hp = 0
