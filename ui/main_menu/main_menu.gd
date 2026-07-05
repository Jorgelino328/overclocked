extends Control

var start_level = "res://levels/tutorial/tutorial.tscn"
#var start_level = "res://levels/level_1/level_1.tscn"

@onready var hover_sfx = $HoverSfx
@onready var animator = $TitleAnimator

@export var music = preload("res://assets/audio/music/menu_music.ogg")

# Define sinais da cena
signal new_game(level: String)
signal continue_game()
signal settings()
signal quit()

func _ready():
	animator.play("show_title")

func setup_connections(controller: Node) -> void:
	new_game.connect(controller._on_next_level)
	continue_game.connect(controller._on_continue_game)
	settings.connect(controller._on_settings)
	quit.connect(controller._on_quit)

func _on_title_animator_animation_finished():
	animator.play("idle")


func _on_mouse_entered() -> void:
	hover_sfx.play()


func _on_play_pressed():
	emit_signal("new_game", start_level)

func _on_settings_pressed() -> void:
	emit_signal("settings")

func _on_exit_pressed() -> void:
	emit_signal("quit")
	
# TODO: Add working continue button
func _on_continue_pressed() -> void:
	pass
