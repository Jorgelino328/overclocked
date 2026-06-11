extends Control

# Nível sendo jogado na hora do game-over
var level_path : String

# Define sinais da cena
signal continue_game()
signal restart_level(level: PackedScene)
signal menu()
signal quit()

func setup_connections(controller: Node) -> void:
	continue_game.connect(controller._on_continue_game)
	restart_level.connect(controller._on_next_level)
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
