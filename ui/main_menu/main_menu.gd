extends Control

func _ready():
	$TitleAnimator.play("show_title")


func _on_title_animator_animation_finished(anim_name):
	$TitleAnimator.play("idle")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level_prototype.tscn")
