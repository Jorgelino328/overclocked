## Script base para a classe Level, herdada por todos os níveis do jogo
class_name Level extends Node2D

# Define o jogador da fase, para ajudar a trocar de cena baseado no seu estado
@export var player : Player

# Importa UI de diálogo
var dialogueUI = preload("res://ui/dialogue_ui/dialogue_ui.tscn")
var freeze = false

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

func freeze_chars():
	freeze = true
	player.process_mode = Node.PROCESS_MODE_DISABLED
	if has_node("NPCs"):
		for e in get_node("NPCs").get_children():
			e.process_mode = Node.PROCESS_MODE_DISABLED

func unfreeze_chars():
	freeze = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	if has_node("NPCs"):
		print()
		for e in get_node("NPCs").get_children():
			e.process_mode = Node.PROCESS_MODE_INHERIT
		

func play_scene(scene):
	var dialogue_instance = dialogueUI.instantiate()
	dialogue_instance.dialoguePath = scene
	add_child(dialogue_instance)

func _on_player_morreu() -> void:
	emit_signal("game_over")
