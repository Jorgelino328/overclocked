extends Control

# Mudar para cena do nível 1 quando estiver pronto
var start_level = "res://levels/testing/level_prototype.tscn"

# Define sinais da cena
signal new_game(level: PackedScene)
signal continue_game()
signal settings()
signal quit()

func _ready():
	$TitleAnimator.play("show_title")


func _on_title_animator_animation_finished():
	$TitleAnimator.play("idle")


func _on_play_pressed():
	$SelectSfx.play()


func _on_mouse_entered() -> void:
	$HoverSfx.play()

#AVISO: Fazer o botão de play depender da música pra trocar de nível não é uma boa prática!
#Idealmente a música deveria tocar num controlador de cena externo para que o som persista
#Essa solução é apenas para esse protótipo simples
func _on_select_sfx_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/level_prototype.tscn")
	
