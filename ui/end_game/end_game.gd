extends Control

# Define sinais da cena
signal menu()
signal quit()

func setup_connections(controller: Node) -> void:
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
func _on_back_pressed() -> void:
	emit_signal("menu")


func _on_quit_button_pressed() -> void:
	emit_signal("quit")
