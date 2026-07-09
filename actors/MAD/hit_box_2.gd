extends Area2D
@onready var hurt_sfx = $HurtSFX
@onready var animation = $GunAnimator2
@export var gun_hp = 25

var signal_emitted = false

signal gun_destroyed()

func _process(_delta) -> void:
	if gun_hp <= 0 and not signal_emitted:
		gun_destroyed.emit()
		signal_emitted = true
		animation.play("destroy")

func take_damage(dmg):
	animation.play("hurt")
	hurt_sfx.play()
	gun_hp -= dmg

func _on_gun_animator_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		queue_free()
