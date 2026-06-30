extends Area2D

@onready var animation = $AnimationPlayer
@export var heal_amount := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("Idle")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var curr_hp = body.hp
		if curr_hp <= body.max_hp:
			body.heal(heal_amount)
			queue_free()
