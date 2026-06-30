extends Control

# Mudar para cena do nível 1 quando estiver pronto
var start_level = "res://levels/tutorial/tutorial.tscn"

# Define sinais da cena
signal new_game(level: String)
signal continue_game()
signal settings()
signal quit()

func _ready():
	$TitleAnimator.play("show_title")

func setup_connections(controller: Node) -> void:
	new_game.connect(controller._on_next_level)
	continue_game.connect(controller._on_continue_game)
	settings.connect(controller._on_settings)
	quit.connect(controller._on_quit)

func _on_title_animator_animation_finished():
	$TitleAnimator.play("idle")


func _on_mouse_entered() -> void:
	$HoverSfx.play()


func _on_play_pressed():
	emit_signal("new_game", start_level)

func _on_settings_pressed() -> void:
	emit_signal("settings")

func _on_exit_pressed() -> void:
	emit_signal("quit")
	
# TODO: Add working continue button
func _on_continue_pressed() -> void:
	pass
