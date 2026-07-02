extends Area2D

@onready var sprite = $NumberSprite
@onready var animation = $NumberAnimation

@export var speed = 50
@export var active = true

func _ready() -> void:
	if active:
		animation.play("spawn_g")
	else:
		animation.play("spawn_r")
	sprite.frame = randi_range(0,1)
	speed = randi_range(30,50)


func _process(delta: float) -> void:
	position -= transform.y * speed * delta

func free_number():
	if active:
		animation.play("disappear_g")
	else:
		animation.play("disappear_r")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "disappear_r" || anim_name == "disappear_g":
		queue_free()
