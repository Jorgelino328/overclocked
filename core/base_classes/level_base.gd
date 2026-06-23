## Script base para a classe Level, herdada por todos os níveis do jogo
class_name Level extends Node2D

# Define o jogador da fase, para ajudar a trocar de cena baseado no seu estado
@export var player : Player

# Importa UI de diálogo
var dialogueUI = preload("res://ui/dialogue_ui/dialogue_ui.tscn")

# Define sinais da cena
signal next_level(level: String)
signal menu()
signal quit()

func setup_connections(controller: Node) -> void:
	next_level.connect(controller._on_next_level)
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

### Se o jogador morre, troca para tela de game over
### WARNING: Lembre de adicionar super._process(delta) na classe filha caso for adicionar um novo _process
#func _process(delta):
	#if player.hp <= 0:
		#emit_signal("next_level", get_parent().GAME_OVER)


# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
