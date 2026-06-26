extends Control

# Nível sendo jogado na hora do game-over
var level_path : String

signal continue_game()
signal restart_level(level_path: String) 
signal menu() 
signal quit()

func _ready():
	print("A tela de Game Over abriu!")
	print("Caminho da fase salvo para o Restart: ", level_path)

func setup_connections(controller: Node) -> void:
	continue_game.connect(controller._on_continue_game)
	restart_level.connect(controller._on_next_level)
	menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

# ==========================================
# EVENTOS DOS BOTÕES
# ==========================================

func _on_restart_pressed() -> void:
	emit_signal("restart_level", level_path)

func _on_back_pressed() -> void:
	emit_signal("menu")


func _on_quit_pressed() -> void:
	emit_signal("quit")
