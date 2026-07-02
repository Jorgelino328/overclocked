## Script base para a classe Level, herdada por todos os níveis do jogo
class_name Level extends Node2D

# Define o jogador da fase, para ajudar a trocar de cena baseado no seu estado
@export var player : Player

# Importa UI de diálogo
var dialogueUI = preload("res://ui/dialogue_ui/dialogue_ui.tscn")

var freeze = true


# Define sinais da cena
signal next_level(level: String)
signal level_cleared(proxima_fase_path: String)
signal game_over()
signal menu()
signal quit()

func _ready() -> void:
	if player:
		player.morreu.connect(_on_player_morreu)
	else:
		call_deferred("_conectar_player_dinamico")

func _conectar_player_dinamico() -> void:
	for child in get_children():
		if child is Player:
			player = child
			player.morreu.connect(_on_player_morreu)
			break

func setup_connections(controller) -> void:
	next_level.connect(controller._on_next_level)
	game_over.connect(controller._on_game_over)
	level_cleared.connect(controller._on_level_clear)
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

# Função acionada assim que o Robonildo termina a animação de morte
func _on_player_morreu() -> void:
	emit_signal("game_over")

func freeze_chars():
	if not get_tree().paused:
		get_tree().paused = true

func unfreeze_chars():
	if get_tree().paused:
		get_tree().paused = false
		
func play_scene(scene):
	var dialogue_instance = dialogueUI.instantiate()
	dialogue_instance.dialoguePath = scene
	dialogue_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	dialogue_instance.dialogue_finished.connect(_on_dialogue_finished)
	add_child(dialogue_instance)

func _on_dialogue_finished():
	get_tree().paused = false
