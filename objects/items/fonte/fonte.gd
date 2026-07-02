extends Area2D

@onready var animation = $AnimationPlayer
@export var heal_amount := 0

signal found_psu()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Idle")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if !body.has_psu:
			body.heal(heal_amount) # Tô curando 0 só pra tocar o sfx msm.
			body.has_psu = true
			found_psu.emit()
			queue_free()
