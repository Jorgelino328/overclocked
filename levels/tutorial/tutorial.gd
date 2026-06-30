extends Level

enum DialogueState { START, WAKEUP_1, WAKEUP_2, INTRO, TUTORIAL_1, TUTORIAL_2, TUTORIAL_3, END }

@onready var dialogue_box = $DialogueUI
@onready var dark_screen = $DarkScreen
@onready var animation = $AnimationPlayer
@onready var level_path = "res://levels/nivel_1/nivel_1.tscn"

var curr_dialogue = DialogueState.START
var wakeup_dialogue_1 = "res://assets/dialogue/wakeup_1.json"
var wakeup_dialogue_2 = "res://assets/dialogue/wakeup_2.json"
var intro_dialogue = "res://assets/dialogue/intro.json"
var tutorial_basic = "res://assets/dialogue/tutorial_basic.json"
var tutorial_mec_1 = "res://assets/dialogue/tutorial_mec_1.json"
var tutorial_mec_2 = "res://assets/dialogue/tutorial_mec_2.json"
var tutorial_partes_1 = "res://assets/dialogue/tutorial_partes_1.json"
var tutorial_partes_2 = "res://assets/dialogue/tutorial_partes_2.json"
var tutorial_ufrn_1 = "res://assets/dialogue/tutorial_ufrn_1.json"
var tutorial_ufrn_2 = "res://assets/dialogue/tutorial_ufrn_2.json"
var wait = true
var freeze = true
var surged = false
var awake = false

@onready var gab = $NPCs/Gabriel
@onready var wil = $NPCs/William
@onready var oli = $NPCs/Olivia

func _ready() -> void:
	#connect_signals()
	pass
	
func _process(_delta):
	# Por algum motivo, o personagem sempre começava o jogo pulando,
	# então adicionei uma espera de 0.1s antes de começar as cutscenes
	# pra dar tempo dele pisar no chão
	if !wait:
		if(!has_node("DialogueUI")):
			if awake:
				unfreeze_chars()
			match curr_dialogue:
				DialogueState.START:
					play_scene(wakeup_dialogue_1)
					curr_dialogue = DialogueState.WAKEUP_1
				DialogueState.WAKEUP_1:
					play_scene(wakeup_dialogue_1)
					curr_dialogue = DialogueState.WAKEUP_2
				DialogueState.WAKEUP_2:
					if surged:
						play_scene(wakeup_dialogue_2)
						curr_dialogue = DialogueState.INTRO
					elif !animation.is_playing():
						animation.play("surge")
				DialogueState.INTRO:
					if awake:
						play_scene(intro_dialogue)
						curr_dialogue = DialogueState.END
					elif !animation.is_playing():
						animation.play("wake_up")
						
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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "surge":
		surged = true
	else:
		awake = true
		dark_screen.queue_free()


func _on_timer_timeout() -> void:
	wait = false
