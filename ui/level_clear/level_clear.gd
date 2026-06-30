extends Control

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
func _on_next_pressed() -> void:
	emit_signal("next_level", level_path)

func _on_menu_pressed() -> void:
	emit_signal("menu")

func _on_quit_pressed() -> void:
	emit_signal("quit")
