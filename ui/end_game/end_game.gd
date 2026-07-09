extends Control

@onready var hover_sfx = $HoverSFX

# Define sinais da cena
signal menu()
signal quit()
signal credits()

func setup_connections(controller: Node) -> void:
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)
	credits.connect(controller._on_credits)

# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
func _on_back_pressed() -> void:
	emit_signal("menu")

func _on_quit_button_pressed() -> void:
	emit_signal("quit")

func _on_credits_pressed() -> void:
	emit_signal("credits")

func _on_mouse_entered() -> void:
	hover_sfx.play()
