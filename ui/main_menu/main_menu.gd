extends Control

func _ready():
	$TitleAnimator.play("show_title")


func _on_title_animator_animation_finished(anim_name):
	$TitleAnimator.play("idle")
