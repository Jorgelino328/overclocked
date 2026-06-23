extends Level

enum DialogueState { START, TUTORIAL, END }

@onready var dialogue_box = $DialogueUI
@onready var level_path = "res://levels/nivel_1/nivel_1.tscn"

var curr_dialogue = DialogueState.START
var intro_dialogue = "res://assets/dialogue/tutorial.json"
var freeze = true

func _ready() -> void:
	player.sprite.frame = 23
	player.rotation = - PI/2
	
func _process(_delta):
	if(!has_node("DialogueUI")):
		match curr_dialogue:
			DialogueState.START:
				play_scene(intro_dialogue)
				curr_dialogue = DialogueState.TUTORIAL
			DialogueState.TUTORIAL:
				pass
			DialogueState.END:
				dialogue_box.queue_free()
	else:
		freeze_chars()

func play_scene(scene):
	var dialogue_instance = dialogueUI.instantiate()
	dialogue_instance.dialoguePath = scene
	add_child(dialogue_instance)
	
func freeze_chars():
	freeze = true
	$Robonildo.process_mode = Node.PROCESS_MODE_DISABLED
	for e in $NPCs.get_children():
		e.process_mode = Node.PROCESS_MODE_DISABLED

func unfreeze_chars():
	freeze = false
	$Robonildo.process_mode = Node.PROCESS_MODE_INHERIT
	for e in $NPCs.get_children():
		e.process_mode = Node.PROCESS_MODE_INHERIT


func _on_goal_body_entered(body: Node2D) -> void:
	if body is Player:
		level_finish()

func level_finish():
	emit_signal("next_level", level_path)
