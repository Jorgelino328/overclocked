class_name Level extends Node2D

# Próximo nível pra direcionar o jogador
var level_path : String

# Define sinais da cena
signal next_level(level: PackedScene)
signal menu()
signal quit()

func setup_connections(controller: Node) -> void:
	next_level.connect(controller._on_next_level)
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
