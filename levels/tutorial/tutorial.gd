# extends Level
extends "res://core/base_classes/level_base.gd" # (Use o caminho que você copiou)

enum DialogueState { START, INTRO, TUTORIAL_1, TUTORIAL_2, TUTORIAL_3, END }

@onready var dialogue_box = $DialogueUI
@onready var level_path = "res://levels/nivel_1/nivel_1.tscn"

var curr_dialogue = DialogueState.START
var intro_dialogue = "res://assets/dialogue/intro.json"
var tutorial_basic = "res://assets/dialogue/tutorial_basic.json"
var tutorial_mec_1 = "res://assets/dialogue/tutorial_mec_1.json"
var tutorial_partes_1 = "res://assets/dialogue/tutorial_partes_1.json"
var tutorial_ufrn_1 = "res://assets/dialogue/tutorial_ufrn.json"
var freeze = true
var awake = true

@onready var gab = $NPCs/Gabriel
@onready var wil = $NPCs/William
@onready var oli = $NPCs/Olivia

func _ready() -> void:
	#connect_signals()
	pass
	
func _process(_delta):
	if(!has_node("DialogueUI")):
		unfreeze_chars()
		match curr_dialogue:
			DialogueState.START:
				#player.animation_player.play("wake_up")
				#$Timer.start()
				curr_dialogue = DialogueState.INTRO
			DialogueState.INTRO:
				if awake :
					play_scene(intro_dialogue)
					curr_dialogue = DialogueState.END
					print("awake")
			DialogueState.TUTORIAL_1:
				pass
			DialogueState.TUTORIAL_2:
				pass
			DialogueState.TUTORIAL_3:
				pass
			DialogueState.END:
				if dialogue_box:
					dialogue_box.queue_free()
	else:
		freeze_chars()

func connect_signals():
	gab.tutorial_mec_1.connect(play_scene.bind(tutorial_mec_1))
	wil.tutorial_partes_1.connect(play_scene.bind(tutorial_partes_1))
	oli.tutorial_ufrn_1.connect(play_scene.bind(tutorial_ufrn_1))


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


func _on_timer_timeout() -> void:
	awake = true
	curr_dialogue = DialogueState.START
