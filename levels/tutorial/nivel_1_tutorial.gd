extends Level

enum DialogueState { START, TUTORIAL, END }

@onready var dialogue_box = $DialogueUI

var curr_dialogue = DialogueState.START
var intro_dialogue = "res://assets/dialogue/tutorial.json"

func _process(delta):
	match curr_dialogue:
		DialogueState.START:
			play_scene(intro_dialogue)
			curr_dialogue = DialogueState.TUTORIAL
		DialogueState.TUTORIAL:
			pass
		DialogueState.END:
			dialogue_box.queue_free()
		

func play_scene(scene):
	var dialogue_instance = dialogueUI.instantiate()
	dialogue_instance.dialoguePath = scene
	add_child(dialogue_instance)
