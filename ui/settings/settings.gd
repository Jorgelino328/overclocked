extends Control

@export var music = preload("res://assets/audio/music/menu_music.ogg")

# Define sinais da cena
signal menu()

func setup_connections(controller: Node) -> void:
	menu.connect(controller._on_menu)

# TODO: Criar os eventos para cada botão e emitir os sinais apropriados
