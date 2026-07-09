extends Level

enum DialogueState 
{ 
	WAKEUP_1, 
	WAKEUP_2, 
	INTRO, 
	T_BASIC, 
	T_MEC_1, 
	T_MEC_2, 
	T_PARTES_1, 
	T_PARTES_2,
	T_UFRN_1, 
	T_UFRN_2,  
	END 
}

@onready var dark_screen = $DarkScreen
@onready var animation = $AnimationPlayer
@onready var level_path = "res://levels/level_1/level_1.tscn"
@export var music = preload("res://assets/audio/music/deepSpace.ogg")

var curr_dialogue = DialogueState.WAKEUP_1
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
var surged = false
var awake = false

@onready var gab = $NPCs/Gabriel
@onready var wil = $NPCs/William
@onready var oli = $NPCs/Olivia

func _ready() -> void:
	player.visible = false
	connect_signals()
	
func _process(_delta):
	# Por algum motivo, o personagem sempre começava o jogo pulando,
	# então adicionei uma espera de 0.1s antes de começar as cutscenes
	# pra dar tempo dele pisar no chão
	if !wait:
		if(!has_node("DialogueUI")):
			if awake:
				unfreeze_chars()
			match curr_dialogue:
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
							curr_dialogue = DialogueState.T_BASIC
						elif !animation.is_playing():
							player.visible = true
							animation.play("wake_up")
					DialogueState.T_BASIC:
						play_scene(tutorial_basic)
						gab.has_dialogue = true
						wil.has_dialogue = true
						oli.has_dialogue = true
						curr_dialogue = DialogueState.END
					DialogueState.T_MEC_1:
						play_scene(tutorial_mec_1)
						curr_dialogue = DialogueState.END
					DialogueState.T_MEC_2:
						play_scene(tutorial_mec_2)
						curr_dialogue = DialogueState.END
					DialogueState.T_PARTES_1:
						play_scene(tutorial_partes_1)
						curr_dialogue = DialogueState.END
					DialogueState.T_PARTES_2:
						play_scene(tutorial_partes_2)
						curr_dialogue = DialogueState.END
					DialogueState.T_UFRN_1:
						play_scene(tutorial_ufrn_1)
						curr_dialogue = DialogueState.END
					DialogueState.T_UFRN_2:
						play_scene(tutorial_ufrn_2)
						curr_dialogue = DialogueState.END
					DialogueState.END:
						pass
		else:
			freeze_chars()

func connect_signals():
	gab.tutorial_mec_1.connect(play_scene.bind(tutorial_mec_1))
	gab.tutorial_mec_2.connect(play_scene.bind(tutorial_mec_2))
	wil.tutorial_partes_1.connect(play_scene.bind(tutorial_partes_1))
	wil.tutorial_partes_2.connect(play_scene.bind(tutorial_partes_2))
	oli.tutorial_ufrn_1.connect(play_scene.bind(tutorial_ufrn_1))
	oli.tutorial_ufrn_2.connect(play_scene.bind(tutorial_ufrn_2))


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
