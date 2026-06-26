## Script base para a classe Level, herdada por todos os níveis do jogo
class_name Level extends Node2D

# Define o jogador da fase, para ajudar a trocar de cena baseado no seu estado
@export var player : Player

# Importa UI de diálogo
var dialogueUI = preload("res://ui/dialogue_ui/dialogue_ui.tscn")

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

### Se o jogador morre, troca para tela de game over
### WARNING: Lembre de adicionar super._process(delta) na classe filha caso for adicionar um novo _process
#func _process(delta):
	#if player.hp <= 0:
		#emit_signal("next_level", get_parent().GAME_OVER)


# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
