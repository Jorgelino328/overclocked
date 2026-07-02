extends Area2D

@onready var animation = $AnimationPlayer
@export var heal_amount := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Idle")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.has_hdd:
			body.heal(heal_amount) # Tô curando 0 só pra tocar o sfx msm.
			body.has_hdd = true
			queue_free()
